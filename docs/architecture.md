# Kiến trúc dự án Monopoly Game

## Tổng quan
Dự án được xây dựng trên Flutter framework kết hợp với Flame game engine để tạo nên trải nghiệm game 2D trên Android, iOS, Web và Windows.

## Cấu trúc thư mục hiện tại
```
lib/
  ├── main.dart                  # Điểm vào ứng dụng, khởi tạo GameWidget
  ├── game.dart                  # Lớp AppGame (FlameGame) + DiceButton component
  ├── controllers/
  │   └── game_controller.dart   # GameController: xúc xắc, di chuyển, chuyển lượt
  ├── models/
  │   ├── player.dart            # Player: tên, tiền, vị trí (0-39)
  │   └── tile.dart              # Tile: enum TileType + dữ liệu ô
  ├── views/
  │   └── board_view.dart        # BoardView: vẽ bàn 40 ô + token người chơi
  └── data/
      └── board_data.dart        # 40 ô Monopoly chuẩn (tên, giá, rent, group)
```

## Kiến trúc chính
- **Flutter Framework**: Quản lý vòng đời ứng dụng, MaterialApp
- **Flame Engine**: Vòng lặp game, render, input (TapCallbacks), component system
- **GameController**: Lưu trạng thái game (danh sách player, lượt hiện tại), cung cấp methods cho logic chơi
- **BoardView**: PositionComponent vẽ bàn 40 ô và token người chơi bằng Canvas

## Quy tắc mã
- Tuân thủ phân tích tĩnh của Flutter (analysis_options.yaml)
- camelCase cho biến/hàm, PascalCase cho lớp/widget
- Tách biệt logic game (controllers) và hiển thị (views)
