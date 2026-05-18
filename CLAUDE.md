# CLAUDE.md — Hướng dẫn AI cho dự án Monopoly Game

## Ngôn ngữ
- Luôn phản hồi và giải thích bằng **tiếng Việt**
- Giữ nguyên thuật ngữ kỹ thuật tiếng Anh (tên class, method, package, v.v.)

## Dự án
- Flutter + Flame engine game Monopoly
- Chạy được trên: Chrome, Windows, Android, iOS
- Cấu trúc MVC: `controllers/`, `models/`, `views/`, `data/`

## Kiến trúc
```
lib/
  main.dart           — Entry point + Flutter overlay UI (HUD, dialogs)
  game.dart           — AppGame (FlameGame): điều khiển luồng game
  controllers/
    game_controller.dart — Toàn bộ logic Monopoly (mua, thuê, jail, cards...)
  models/
    player.dart, tile.dart, card.dart
  views/
    board_view.dart   — Vẽ bàn 40 ô, token, ownership, houses (Canvas)
  data/
    board_data.dart   — 40 ô Monopoly chuẩn
    cards_data.dart   — 28 thẻ Chance + Community Chest
```

## Quy tắc code
- **Dart:** camelCase cho biến/hàm, PascalCase cho class
- **Không thêm comments trừ khi cần giải thích logic phức tạp**
- Ưu tiên code đơn giản, dễ đọc hơn tối ưu sớm
- Chạy `flutter analyze` sau mỗi thay đổi, fix hết lỗi trước khi báo cáo
- Nếu cần thêm package → thêm vào `pubspec.yaml` → chạy `flutter pub get`

## Luồng game (quan trọng)
1. HUD = Flutter overlay (`overlayBuilderMap` trong `main.dart`)
2. Board = Flame `PositionComponent` vẽ Canvas
3. Logic = `GameController` thuần Dart, không phụ thuộc Flutter/Flame
4. Khi thêm tính năng mới: cập nhật `GameController` trước → UI sau

## Các lệnh thường dùng
- `flutter analyze` — Kiểm tra lỗi
- `flutter run -d chrome` — Chạy trên web
- `flutter pub get` — Cập nhật dependencies
- `flutter build apk` — Build Android

## Mô hình đang dùng
- DeepSeek V4 Flash Free (qua opencode Zen) — model miễn phí
- Context window hạn chế → ưu tiên surgical changes, không viết lại cả file

## Các tính năng đã hoàn thành
Xem `docs/features.md` và `docs/roadmap.md` để biết chi tiết.

## Khi gặp lỗi
1. Chạy `flutter analyze` để xem danh sách lỗi
2. Đọc kỹ thông báo lỗi
3. Fix từng lỗi một
4. Chạy lại `flutter analyze` để xác nhận
