enum CardType {
  collectMoney,
  payMoney,
  moveTo,
  goToJail,
  getOutOfJail,
  collectFromPlayers,
  payPerHouse,
  goBack,
}

class GameCard {
  final String title;
  final String description;
  final CardType type;
  final int? amount;
  final int? targetTile;
  final bool isChance;

  GameCard({
    required this.title,
    required this.description,
    required this.type,
    this.amount,
    this.targetTile,
    required this.isChance,
  });
}
