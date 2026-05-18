class Player {
  final String name;
  int money;
  int position;
  bool inJail = false;
  int jailTurns = 0;
  int jailFreeCards = 0;
  bool isBankrupt = false;

  Player({
    required this.name,
    this.money = 1500,
    this.position = 0,
  });

  void move(int steps) {
    position = (position + steps) % 40;
  }

  void moveTo(int tileIndex) {
    position = tileIndex % 40;
  }

  void addMoney(int amount) {
    money += amount;
  }

  bool spendMoney(int amount) {
    if (money >= amount) {
      money -= amount;
      return true;
    }
    return false;
  }

  void goBankrupt() {
    isBankrupt = true;
  }
}
