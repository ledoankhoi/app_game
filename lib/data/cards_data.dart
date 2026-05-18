import '../models/card.dart';

final List<GameCard> chanceCards = [
  GameCard(title: 'Tiến về GO', description: 'Tiến về GO. Nhận \$200.', type: CardType.moveTo, targetTile: 0, amount: 200, isChance: true),
  GameCard(title: 'Đến Illinois Avenue', description: 'Tiến đến Illinois Avenue.', type: CardType.moveTo, targetTile: 24, isChance: true),
  GameCard(title: 'Đến St. Charles Place', description: 'Tiến đến St. Charles Place.', type: CardType.moveTo, targetTile: 11, isChance: true),
  GameCard(title: 'Cổ tức ngân hàng', description: 'Ngân hàng trả cổ tức \$50.', type: CardType.collectMoney, amount: 50, isChance: true),
  GameCard(title: 'Ra tù miễn phí', description: 'Thoát khỏi tù miễn phí.', type: CardType.getOutOfJail, isChance: true),
  GameCard(title: 'Lùi 3 ô', description: 'Lùi lại 3 ô.', type: CardType.goBack, amount: 3, isChance: true),
  GameCard(title: 'Đi tù', description: 'Đi thẳng vào tù.', type: CardType.goToJail, isChance: true),
  GameCard(title: 'Sửa chữa nhà cửa', description: 'Trả \$25/nhà, \$100/khách sạn.', type: CardType.payPerHouse, amount: 25, isChance: true),
  GameCard(title: 'Thuế người nghèo', description: 'Nộp thuế người nghèo \$15.', type: CardType.payMoney, amount: 15, isChance: true),
  GameCard(title: 'Đến Reading Railroad', description: 'Tiến đến Reading Railroad.', type: CardType.moveTo, targetTile: 5, isChance: true),
  GameCard(title: 'Đến Boardwalk', description: 'Tiến đến Boardwalk.', type: CardType.moveTo, targetTile: 39, isChance: true),
  GameCard(title: 'Chủ tịch hội đồng', description: 'Bị bầu làm chủ tịch. Trả \$50 mỗi người.', type: CardType.collectFromPlayers, amount: 50, isChance: true),
  GameCard(title: 'Đáo hạn vay', description: 'Khoản vay xây dựng đáo hạn. Nhận \$150.', type: CardType.collectMoney, amount: 150, isChance: true),
];

final List<GameCard> communityChestCards = [
  GameCard(title: 'Tiến về GO', description: 'Tiến về GO. Nhận \$200.', type: CardType.moveTo, targetTile: 0, amount: 200, isChance: false),
  GameCard(title: 'Sai sót ngân hàng', description: 'Sai sót ngân hàng. Nhận \$200.', type: CardType.collectMoney, amount: 200, isChance: false),
  GameCard(title: 'Viện phí', description: 'Trả viện phí \$100.', type: CardType.payMoney, amount: 100, isChance: false),
  GameCard(title: 'Bán cổ phiếu', description: 'Bán cổ phiếu. Nhận \$50.', type: CardType.collectMoney, amount: 50, isChance: false),
  GameCard(title: 'Ra tù miễn phí', description: 'Thoát khỏi tù miễn phí.', type: CardType.getOutOfJail, isChance: false),
  GameCard(title: 'Đi tù', description: 'Đi thẳng vào tù.', type: CardType.goToJail, isChance: false),
  GameCard(title: 'Đêm nhạc hội', description: 'Đêm nhạc hội lớn. Nhận \$50.', type: CardType.collectMoney, amount: 50, isChance: false),
  GameCard(title: 'Quỹ kỳ nghỉ', description: 'Quỹ kỳ nghỉ đáo hạn. Nhận \$100.', type: CardType.collectMoney, amount: 100, isChance: false),
  GameCard(title: 'Hoàn thuế', description: 'Được hoàn thuế \$20.', type: CardType.collectMoney, amount: 20, isChance: false),
  GameCard(title: 'Bảo hiểm nhân thọ', description: 'Bảo hiểm nhân thọ đáo hạn. Nhận \$100.', type: CardType.collectMoney, amount: 100, isChance: false),
  GameCard(title: 'Học phí', description: 'Đóng học phí \$50.', type: CardType.payMoney, amount: 50, isChance: false),
  GameCard(title: 'Phí tư vấn', description: 'Nhận phí tư vấn \$25.', type: CardType.collectMoney, amount: 25, isChance: false),
  GameCard(title: 'Sửa đường phố', description: 'Trả \$25/nhà, \$100/khách sạn.', type: CardType.payPerHouse, amount: 25, isChance: false),
  GameCard(title: 'Giải nhì hoa hậu', description: 'Giải nhì cuộc thi sắc đẹp. Nhận \$10.', type: CardType.collectMoney, amount: 10, isChance: false),
  GameCard(title: 'Thừa kế', description: 'Được thừa kế \$100.', type: CardType.collectMoney, amount: 100, isChance: false),
];
