import '../models/player.dart';
import '../models/tile.dart';
import '../models/card.dart';
import '../data/board_data.dart';
import '../data/cards_data.dart';
import 'dart:math';

class GameController {
  List<Player> players;
  int currentPlayerIndex;
  late List<Tile> boardTiles;
  bool didPassGo = false;
  bool hasRolledDoubles = false;
  String lastMessage = '';
  int _consecutiveDoubles = 0;
  int _lastDice1 = 0;
  int _lastDice2 = 0;

  late List<GameCard> _chanceDeck;
  late List<GameCard> _communityChestDeck;
  int _chanceIndex = 0;
  int _communityChestIndex = 0;

  GameController({
    required this.players,
    required this.currentPlayerIndex,
  }) {
    boardTiles = standardMonopolyTiles
        .map((t) => Tile(
              name: t.name,
              type: t.type,
              color: t.color,
              price: t.price,
              rent: t.rent,
              groupColor: t.groupColor,
            ))
        .toList();

    _chanceDeck = List.from(chanceCards)..shuffle(Random());
    _communityChestDeck = List.from(communityChestCards)..shuffle(Random());
  }

  int get dice1 => _lastDice1;
  int get dice2 => _lastDice2;
  bool get isDoubles => _lastDice1 == _lastDice2;

  int rollDice() {
    _lastDice1 = 1 + (DateTime.now().millisecondsSinceEpoch % 6);
    _lastDice2 = 1 + ((DateTime.now().millisecondsSinceEpoch >> 3) % 6);

    if (isDoubles) {
      _consecutiveDoubles++;
    } else {
      _consecutiveDoubles = 0;
    }

    return _lastDice1 + _lastDice2;
  }

  bool get threeDoublesInARow => _consecutiveDoubles >= 3;

  // --- Movement ---

  int moveCurrentPlayer(int steps) {
    final player = players[currentPlayerIndex];
    final oldPosition = player.position;
    player.move(steps);
    didPassGo = (oldPosition + steps) >= 40;
    return player.position;
  }

  bool moveToTile(int tileIndex) {
    final player = players[currentPlayerIndex];
    if (tileIndex < player.position) {
      didPassGo = true;
    }
    player.moveTo(tileIndex);
    return didPassGo;
  }

  bool goBack(int spaces) {
    final player = players[currentPlayerIndex];
    player.position = (player.position - spaces + 40) % 40;
    return true;
  }

  void addGoMoney() {
    if (didPassGo) {
      players[currentPlayerIndex].addMoney(200);
    }
  }

  // --- Buy ---

  bool buyCurrentTile() {
    final player = players[currentPlayerIndex];
    final tile = boardTiles[player.position];
    if (tile.isOwned || tile.price == null) return false;
    if (player.spendMoney(tile.price!)) {
      tile.ownerIndex = currentPlayerIndex;
      return true;
    }
    return false;
  }

  // --- Rent ---

  int calculateRent(int tileIndex) {
    final tile = boardTiles[tileIndex];
    if (!tile.isOwned) return 0;

    if (tile.type == TileType.railroad) {
      int count = 0;
      for (final t in boardTiles) {
        if (t.type == TileType.railroad && t.ownerIndex == tile.ownerIndex) {
          count++;
        }
      }
      return 25 * (1 << (count - 1));
    }

    if (tile.type == TileType.utility) {
      int count = 0;
      for (final t in boardTiles) {
        if (t.type == TileType.utility && t.ownerIndex == tile.ownerIndex) {
          count++;
        }
      }
      final multiplier = count == 1 ? 4 : 10;
      return (_lastDice1 + _lastDice2) * multiplier;
    }

    if (tile.rent == null) return 0;

    switch (tile.houses) {
      case 0: return tile.rent!;
      case 1: return tile.rent! * 5;
      case 2: return tile.rent! * 15;
      case 3: return tile.rent! * 45;
      case 4: return tile.rent! * 90;
      case 5: return tile.rent! * 135;
      default: return tile.rent!;
    }
  }

  bool payRentForCurrentTile() {
    final player = players[currentPlayerIndex];
    final tile = boardTiles[player.position];
    if (!tile.isOwned || tile.ownerIndex == currentPlayerIndex) return false;
    final owner = players[tile.ownerIndex];
    final rent = calculateRent(player.position);
    if (player.spendMoney(rent)) {
      owner.addMoney(rent);
      return true;
    }
    return false;
  }

  // --- Tax ---

  int handleTaxForCurrentTile() {
    final player = players[currentPlayerIndex];
    final tile = boardTiles[player.position];
    if (tile.type == TileType.tax) {
      final tax = tile.name.contains('Luxury') ? 100 : 200;
      player.spendMoney(tax);
      return tax;
    }
    return 0;
  }

  // --- Monopoly & Building ---

  bool hasMonopoly(int playerIndex, int groupColor) {
    final groupTiles = boardTiles
        .where((t) => t.groupColor == groupColor && t.type == TileType.property)
        .toList();
    if (groupTiles.isEmpty) return false;
    return groupTiles.every((t) => t.ownerIndex == playerIndex);
  }

  List<int> getBuildableTiles(int playerIndex) {
    final result = <int>[];
    for (int i = 0; i < boardTiles.length; i++) {
      final tile = boardTiles[i];
      if (tile.ownerIndex == playerIndex &&
          tile.type == TileType.property &&
          tile.groupColor != null &&
          hasMonopoly(playerIndex, tile.groupColor!) &&
          tile.houses < 5) {
        final groupTiles = boardTiles
            .where((t) => t.groupColor == tile.groupColor && t.type == TileType.property)
            .toList();
        final minHouses = groupTiles.map((t) => t.houses).reduce((a, b) => a < b ? a : b);
        if (tile.houses == minHouses) {
          result.add(i);
        }
      }
    }
    return result;
  }

  bool buyHouse(int tileIndex) {
    if (tileIndex < 0 || tileIndex >= boardTiles.length) return false;
    final tile = boardTiles[tileIndex];
    if (tile.ownerIndex != currentPlayerIndex) return false;
    if (tile.type != TileType.property) return false;
    if (tile.houses >= 5) return false;
    if (!hasMonopoly(currentPlayerIndex, tile.groupColor!)) return false;

    final houseCost = tile.price! ~/ 2;
    if (!players[currentPlayerIndex].spendMoney(houseCost)) return false;

    tile.houses++;
    return true;
  }

  int getHouseCost(int tileIndex) {
    if (tileIndex < 0 || tileIndex >= boardTiles.length) return 0;
    final tile = boardTiles[tileIndex];
    if (tile.price == null) return 0;
    return tile.price! ~/ 2;
  }

  // --- Cards ---

  GameCard drawChance() {
    final card = _chanceDeck[_chanceIndex];
    _chanceIndex = (_chanceIndex + 1) % _chanceDeck.length;
    return card;
  }

  GameCard drawCommunityChest() {
    final card = _communityChestDeck[_communityChestIndex];
    _communityChestIndex = (_communityChestIndex + 1) % _communityChestDeck.length;
    return card;
  }

  void executeCard(GameCard card) {
    final player = players[currentPlayerIndex];

    switch (card.type) {
      case CardType.collectMoney:
        if (card.amount != null) player.addMoney(card.amount!);
        break;
      case CardType.payMoney:
        if (card.amount != null) player.spendMoney(card.amount!);
        break;
      case CardType.moveTo:
        if (card.targetTile != null) {
          final oldPos = player.position;
          if (card.targetTile! < oldPos && card.targetTile != 0) {
            didPassGo = true;
          } else if (card.targetTile == 0 && oldPos != 0) {
            didPassGo = true;
          }
          player.moveTo(card.targetTile!);
        }
        break;
      case CardType.goToJail:
        sendToJail(currentPlayerIndex);
        break;
      case CardType.getOutOfJail:
        player.jailFreeCards++;
        break;
      case CardType.collectFromPlayers:
        if (card.amount != null) {
          for (final p in players) {
            if (p != player && !p.isBankrupt) {
              if (p.spendMoney(card.amount!)) {
                player.addMoney(card.amount!);
              }
            }
          }
        }
        break;
      case CardType.payPerHouse:
        if (card.amount != null) {
          int totalHouses = 0;
          int totalHotels = 0;
          for (final t in boardTiles) {
            if (t.ownerIndex == currentPlayerIndex) {
              if (t.houses < 5) {
                totalHouses += t.houses;
              } else {
                totalHotels++;
              }
            }
          }
          final total = totalHouses * card.amount! + totalHotels * card.amount! * 4;
          player.spendMoney(total);
        }
        break;
      case CardType.goBack:
        if (card.amount != null) goBack(card.amount!);
        break;
    }
  }

  // --- Jail ---

  void sendToJail(int playerIndex) {
    final player = players[playerIndex];
    player.position = 10;
    player.inJail = true;
    player.jailTurns = 0;
  }

  bool tryJailDoubles() {
    if (!isDoubles) return false;
    final player = players[currentPlayerIndex];
    player.inJail = false;
    player.jailTurns = 0;
    return true;
  }

  bool payJailFine() {
    final player = players[currentPlayerIndex];
    if (player.spendMoney(50)) {
      player.inJail = false;
      player.jailTurns = 0;
      return true;
    }
    return false;
  }

  bool useJailFreeCard() {
    final player = players[currentPlayerIndex];
    if (player.jailFreeCards > 0) {
      player.jailFreeCards--;
      player.inJail = false;
      player.jailTurns = 0;
      return true;
    }
    return false;
  }

  // --- Bankruptcy ---

  bool declareBankruptcy(int creditorIndex) {
    final player = players[currentPlayerIndex];
    player.goBankrupt();

    for (final tile in boardTiles) {
      if (tile.ownerIndex == currentPlayerIndex) {
        if (creditorIndex >= 0 && creditorIndex < players.length) {
          tile.ownerIndex = creditorIndex;
          tile.houses = 0;
        } else {
          tile.ownerIndex = -1;
          tile.houses = 0;
        }
      }
    }

    if (creditorIndex >= 0 && creditorIndex < players.length) {
      players[creditorIndex].addMoney(player.money);
    }
    player.money = 0;

    return true;
  }

  bool get isGameOver {
    final active = players.where((p) => !p.isBankrupt).toList();
    return active.length <= 1;
  }

  Player? get winner {
    final active = players.where((p) => !p.isBankrupt).toList();
    if (active.length == 1) return active.first;
    if (active.isEmpty && players.isNotEmpty) return players.first;
    return null;
  }

  List<Player> get activePlayers => players.where((p) => !p.isBankrupt).toList();

  // --- Turn ---

  void nextPlayer() {
    int next = (currentPlayerIndex + 1) % players.length;
    int attempts = 0;
    while (players[next].isBankrupt && attempts < players.length) {
      next = (next + 1) % players.length;
      attempts++;
    }
    currentPlayerIndex = next;
    didPassGo = false;
    hasRolledDoubles = false;
  }

  void resetDoubles() {
    _consecutiveDoubles = 0;
    hasRolledDoubles = false;
  }

  Player get currentPlayer => players[currentPlayerIndex];
  List<Player> get allPlayers => players;
}
