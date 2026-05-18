# Monopoly Test 01

A Flutter-based Monopoly board game built with the **Flame game engine**.  

## Tính năng đã hoàn thành

- **Bàn Monopoly 40 ô** chuẩn với dữ liệu đầy đủ (tên, giá, rent, nhóm màu)
- **2 người chơi**, mỗi người $1500 ban đầu
- **Xúc xắc** (2 viên), di chuyển vòng quanh bàn
- **Mua bán đất** — popup mua khi dừng ở ô trống
- **Qua GO** +$200, **Thuế** Income/Luxury Tax
- **Tiền thuê** — tính theo cấp độ nhà (railroad, utility, property)
- **Monopoly & Xây nhà** — sở hữu hết nhóm màu, xây tối đa 4 nhà + hotel
- **Thẻ May & Cộng Đồng** — 13 thẻ Chance + 15 thẻ Community Chest
- **Jail** — tung double ra tù, trả $50, thẻ ra tù, 3 lượt forced pay
- **3 doubles liên tiếp** → vào tù
- **Phá sản** — chuyển tài sản, loại người chơi
- **Game Over** — còn 1 người → thắng, nút chơi lại
- **HUD** — thông tin người chơi, trạng thái, nút tung xúc xắc (Flutter overlay)

## Chạy thử

```bash
flutter run -d chrome
flutter run -d windows
flutter run -d android
```

## Cấu trúc thư mục

```
lib/
  ├── main.dart                  # Entry point + overlay UI
  ├── game.dart                  # AppGame (FlameGame) - logic game
  ├── controllers/
  │   └── game_controller.dart   # Toàn bộ logic Monopoly
  ├── models/
  │   ├── player.dart            # Người chơi
  │   ├── tile.dart              # Ô trên bàn
  │   └── card.dart              # Thẻ May/Cộng Đồng
  ├── views/
  │   └── board_view.dart        # Vẽ bàn + token + nhà
  └── data/
      ├── board_data.dart        # 40 ô Monopoly chuẩn
      └── cards_data.dart        # 28 thẻ Chance + Community Chest
docs/
  ├── architecture.md
  ├── features.md
  └── roadmap.md
```

## Tech Stack

- Flutter 3.41+
- Flame 1.37+
- Dart 3.11+
