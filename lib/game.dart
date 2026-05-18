import 'package:flame/game.dart';
import '../controllers/game_controller.dart';
import '../models/player.dart';
import '../models/tile.dart';
import '../models/card.dart';
import '../views/board_view.dart';

class AppGame extends FlameGame {
  late GameController _gameController;
  bool _isRolling = false;
  GameCard? _pendingCard;

  // --- Getters for UI ---

  String get currentTileName =>
      _gameController.boardTiles[_gameController.currentPlayer.position].name;

  int? get currentTilePrice =>
      _gameController.boardTiles[_gameController.currentPlayer.position].price;

  int get currentTileRent =>
      _gameController.calculateRent(_gameController.currentPlayer.position);

  String get player1Info =>
      '${_gameController.players[0].name}: \$${_gameController.players[0].money}';

  String get player2Info =>
      '${_gameController.players[1].name}: \$${_gameController.players[1].money}';

  String get turnText => 'Lượt của: ${_gameController.currentPlayer.name}';

  String get statusText =>
      _gameController.boardTiles[_gameController.currentPlayer.position].name;

  String get lastMessage => _gameController.lastMessage;
  bool get isGameOver => _gameController.isGameOver;
  String? get winnerName => _gameController.winner?.name;

  bool get canBuild =>
      _gameController.getBuildableTiles(_gameController.currentPlayerIndex).isNotEmpty;

  List<int> get buildableTiles =>
      _gameController.getBuildableTiles(_gameController.currentPlayerIndex);

  int getHouseCost(int tileIndex) => _gameController.getHouseCost(tileIndex);

  bool get isInJail => _gameController.currentPlayer.inJail;
  int get jailFreeCards => _gameController.currentPlayer.jailFreeCards;
  int get currentPlayerMoney => _gameController.currentPlayer.money;

  String get buildableTilesString {
    final tiles = buildableTiles;
    if (tiles.isEmpty) return '';
    return tiles.map((i) => _gameController.boardTiles[i].name).join(', ');
  }

  // --- Lifecycle ---

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    final players = [
      Player(name: 'Người chơi 1'),
      Player(name: 'Người chơi 2'),
    ];

    _gameController = GameController(players: players, currentPlayerIndex: 0);

    final boardView = BoardView(gameController: _gameController);
    boardView.size = size;
    add(boardView);

    _updateHUD();
  }

  // --- Roll Dice ---

  void rollDice() {
    if (_isRolling) return;
    _isRolling = true;

    final player = _gameController.currentPlayer;

    if (player.inJail) {
      overlays.add('jailDialog');
      _isRolling = false;
      return;
    }

    _executeRoll();
  }

  void _executeRoll() {
    _isRolling = true;

    final roll = _gameController.rollDice();
    final player = _gameController.currentPlayer;
    _gameController.moveCurrentPlayer(roll);

    String msg =
        '${player.name} tung được ${_gameController.dice1}+${_gameController.dice2}=$roll';

    if (_gameController.threeDoublesInARow) {
      _gameController.sendToJail(_gameController.currentPlayerIndex);
      msg = '${player.name} tung double 3 lần liên tiếp! Đi tù!';
      _gameController.lastMessage = msg;
      _updateHUD();
      _endTurn();
      return;
    }

    _gameController.addGoMoney();
    if (_gameController.didPassGo) {
      msg += ' — Qua GO! + \$200';
    }

    _gameController.lastMessage = msg;
    _updateHUD();
    _checkCurrentTile();
  }

  // --- After roll: handle tile ---

  void _checkCurrentTile() {
    final player = _gameController.currentPlayer;
    final tile = _gameController.boardTiles[player.position];

    switch (tile.type) {
      case TileType.property:
      case TileType.railroad:
      case TileType.utility:
        if (!tile.isOwned && tile.price != null) {
          if (player.money >= tile.price!) {
            _gameController.lastMessage =
                '${player.name}: Mua "${tile.name}" (\$${tile.price})?';
            _updateHUD();
            overlays.add('buyDialog');
            return;
          }
          _gameController.lastMessage =
              '${player.name}: "${tile.name}" — không đủ tiền mua';
        } else if (tile.isOwned &&
            tile.ownerIndex != _gameController.currentPlayerIndex) {
          final paid = _gameController.payRentForCurrentTile();
          final owner = _gameController.players[tile.ownerIndex];
          if (paid) {
            _gameController.lastMessage =
                '${player.name} trả \$${_gameController.calculateRent(player.position)} thuê cho ${owner.name}';
          } else {
            _gameController.lastMessage =
                '${player.name} không đủ tiền trả thuê! Phá sản!';
            _updateHUD();
            _handleBankruptcy(tile.ownerIndex);
            return;
          }
        }
        break;
      case TileType.chance:
        _drawCard(true);
        return;
      case TileType.communityChest:
        _drawCard(false);
        return;
      case TileType.tax:
        final tax = _gameController.handleTaxForCurrentTile();
        _gameController.lastMessage = '${player.name} nộp thuế \$$tax';
        break;
      case TileType.goToJail:
        _gameController.sendToJail(_gameController.currentPlayerIndex);
        _gameController.lastMessage = '${player.name} vào tù!';
        break;
      default:
        break;
    }

    _updateHUD();
    _afterTileAction();
  }

  // --- Cards ---

  void _drawCard(bool isChance) {
    final card = isChance
        ? _gameController.drawChance()
        : _gameController.drawCommunityChest();

    if (card.type == CardType.getOutOfJail) {
      _gameController.executeCard(card);
      _gameController.lastMessage =
          '${_gameController.currentPlayer.name}: "${card.title}" (giữ thẻ ra tù)';
      _updateHUD();
      _afterTileAction();
      return;
    }

    if (card.type == CardType.goToJail) {
      _gameController.executeCard(card);
      _gameController.lastMessage =
          '${_gameController.currentPlayer.name}: "${card.title}"';
      _updateHUD();
      _endTurn();
      return;
    }

    _gameController.lastMessage =
        '${_gameController.currentPlayer.name}: "${card.title}"';
    _pendingCard = card;
    _updateHUD();
    overlays.add('cardDialog');
  }

  void executePendingCard() {
    if (_pendingCard == null) return;
    _gameController.executeCard(_pendingCard!);
    _gameController.lastMessage =
        '${_gameController.currentPlayer.name}: ${_pendingCard!.description}';
    _pendingCard = null;
    overlays.remove('cardDialog');

    if (_gameController.didPassGo) {
      _gameController.addGoMoney();
      _gameController.lastMessage =
          '${_gameController.lastMessage} — Qua GO! + \$200';
    }

    _updateHUD();
    _afterTileAction();
  }

  // --- Building ---

  void buyHouse(int tileIndex) {
    _gameController.buyHouse(tileIndex);
    _gameController.lastMessage =
        '${_gameController.currentPlayer.name} đã xây nhà!';
    _updateHUD();
    overlays.remove('buildDialog');

    if (canBuild) {
      overlays.add('buildDialog');
    } else {
      _afterTileAction();
    }
  }

  void skipBuild() {
    overlays.remove('buildDialog');
    _afterTileAction();
  }

  // --- After tile action: check doubles, building, end turn ---

  void _afterTileAction() {
    if (_gameController.isDoubles) {
      _gameController.lastMessage =
          '${_gameController.lastMessage} — Double! Được tung lại!';
      _updateHUD();
      _gameController.hasRolledDoubles = true;

      if (canBuild) {
        overlays.add('buildDialog');
        return;
      }

      _isRolling = false;
      return;
    }

    if (canBuild) {
      _gameController.lastMessage =
          '${_gameController.lastMessage} — Xây nhà?';
      _updateHUD();
      overlays.add('buildDialog');
      return;
    }

    _endTurn();
  }

  // --- Buy / Skip ---

  void buyTile() {
    if (_gameController.buyCurrentTile()) {
      final tile =
          _gameController.boardTiles[_gameController.currentPlayer.position];
      _gameController.lastMessage =
          '${_gameController.currentPlayer.name} đã mua "${tile.name}"';
    }
    overlays.remove('buyDialog');
    _updateHUD();
    _afterTileAction();
  }

  void skipTile() {
    overlays.remove('buyDialog');
    _gameController.lastMessage = 'Bỏ qua';
    _updateHUD();
    _afterTileAction();
  }

  // --- Jail ---

  void jailRollDice() {
    overlays.remove('jailDialog');

    final roll = _gameController.rollDice();
    if (_gameController.tryJailDoubles()) {
      _gameController.lastMessage =
          '${_gameController.currentPlayer.name} tung double ($roll) — ra tù!';
      _updateHUD();
      _executeRoll();
    } else {
      _gameController.currentPlayer.jailTurns++;
      _gameController.lastMessage =
          '${_gameController.currentPlayer.name} tung $roll — không phải double';
      _updateHUD();

      if (_gameController.currentPlayer.jailTurns >= 3) {
        _gameController.lastMessage = '${_gameController.currentPlayer.name} hết 3 lượt tù! Buộc nộp \$50!';
        _gameController.payJailFine();
        _updateHUD();
        _executeRoll();
      } else {
        _isRolling = false;
        _endTurn();
      }
    }
  }

  void jailPayFine() {
    if (_gameController.payJailFine()) {
      _gameController.lastMessage =
          '${_gameController.currentPlayer.name} trả \$50 ra tù';
      _updateHUD();
      overlays.remove('jailDialog');
      _executeRoll();
    } else {
      _gameController.lastMessage =
          '${_gameController.currentPlayer.name} không đủ tiền nộp phạt!';
      _updateHUD();
    }
  }

  void jailUseCard() {
    if (_gameController.useJailFreeCard()) {
      _gameController.lastMessage =
          '${_gameController.currentPlayer.name} dùng thẻ ra tù';
      _updateHUD();
      overlays.remove('jailDialog');
      _executeRoll();
    }
  }

  // --- Bankruptcy ---

  void _handleBankruptcy(int creditorIndex) {
    _gameController.declareBankruptcy(creditorIndex);

    if (_gameController.isGameOver) {
      _updateHUD();
      overlays.add('gameOverDialog');
      return;
    }

    _updateHUD();
    _endTurn();
  }

  // --- End Turn ---

  void _endTurn() {
    Future.delayed(const Duration(milliseconds: 1200), () {
      _gameController.resetDoubles();
      _gameController.nextPlayer();
      _gameController.lastMessage = '';
      _updateHUD();
      _isRolling = false;
    });
  }

  // --- Game Over ---

  void restartGame() {
    overlays.remove('gameOverDialog');

    final players = [
      Player(name: 'Người chơi 1'),
      Player(name: 'Người chơi 2'),
    ];

    _gameController = GameController(players: players, currentPlayerIndex: 0);

    _isRolling = false;
    _pendingCard = null;

    removeAll(children);
    final boardView = BoardView(gameController: _gameController);
    boardView.size = size;
    add(boardView);

    _updateHUD();
  }

  // --- HUD ---

  void _updateHUD() {
    if (overlays.isActive('hud')) {
      overlays.remove('hud');
    }
    overlays.add('hud');
  }
}
