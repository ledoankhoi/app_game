# Monopoly Game — Hướng dẫn cho AI Agent

## Ngôn ngữ
Phản hồi bằng **tiếng Việt**. Giữ nguyên thuật ngữ kỹ thuật tiếng Anh.

## Dự án
Flutter game Monopoly dùng Flame engine. Chạy trên Chrome, Windows, Android, iOS.

## Cấu trúc thư mục
```
lib/
  main.dart              — Entry point + overlay UI
  game.dart              — AppGame (FlameGame): luồng game
  controllers/
    game_controller.dart — Logic Monopoly (thuần Dart)
  models/
    player.dart          — Người chơi (tên, tiền, position, jail, bankrupt)
    tile.dart            — Ô trên bàn (40 ô, owner, houses)
    card.dart            — Thẻ Chance/Community Chest
  views/
    board_view.dart      — Vẽ bàn Flame Canvas (40 ô, token, nhà)
  data/
    board_data.dart      — 40 ô Monopoly chuẩn
    cards_data.dart      — 28 thẻ
```

## Kiến trúc
- **UI = Flutter Widgets** thông qua `GameWidget.overlayBuilderMap`
- **Board = Flame Component** (PositionComponent, Canvas)
- **Logic = GameController** (thuần Dart, không phụ thuộc UI)
- Luồng: User tap → game.dart xử lý → GameController cập nhật state → overlay refresh

## Code conventions
- camelCase cho biến/hàm, PascalCase cho class
- KHÔNG thêm comments trừ khi thực sự cần
- Ưu tiên surgical changes: sửa tối thiểu, không viết lại cả file
- Luôn chạy `flutter analyze` sau khi code và fix hết lỗi
- Dart SDK ^3.11.5, Flame ^1.37.0

## Các command có sẵn trong opencode
- `/analyze` — flutter analyze
- `/run-web` — flutter run -d chrome
- `/run-win` — flutter run -d windows
- `/test` — flutter test
- `/build-web` — flutter build web

## Model
DeepSeek V4 Flash Free (qua opencode Zen) — free, context có hạn.
→ Viết code ngắn gọn, tránh dài dòng. Chia nhỏ task khi cần.

## Checklist khi thêm tính năng
1. Đọc file liên quan để hiểu code hiện tại
2. Lập kế hoạch ngắn (3-5 bước)
3. Thay đổi từ Models → Controllers → Views → Game → Main
4. Chạy `flutter analyze` và fix lỗi
5. Chạy thử trên Chrome để kiểm tra
6. Cập nhật `docs/features.md` nếu cần
