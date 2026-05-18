enum TileType { go, property, railroad, utility, chance, communityChest, jail, freeParking, goToJail, tax }

class Tile {
  final String name;
  final TileType type;
  final int color;
  final int? price;
  final int? rent;
  final int? groupColor;
  int ownerIndex = -1;
  int houses = 0;

  Tile({
    required this.name,
    required this.type,
    this.color = 0xFFFFFFFF,
    this.price,
    this.rent,
    this.groupColor,
  });

  bool get isOwned => ownerIndex >= 0;
}