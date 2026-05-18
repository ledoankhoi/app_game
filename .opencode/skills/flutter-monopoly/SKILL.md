---
name: flutter-monopoly
description: Use when working on the Monopoly board game built with Flutter & Flame. Covers architecture patterns for MVC-style game logic, Flutter overlay UI, Flame Canvas rendering, and turn-based game mechanics.
---

# Flutter Monopoly Game

## Architecture Pattern

This project uses a **MVC-style** separation:

- **Models** (`lib/models/`) — Pure data classes: `Player`, `Tile`, `GameCard`
- **Controller** (`lib/controllers/game_controller.dart`) — All game logic
- **Views** (`lib/views/board_view.dart`) — Flame Canvas rendering
- **Game** (`lib/game.dart`) — `FlameGame` subclass, bridges controller ↔ UI
- **UI** (`lib/main.dart`) — Flutter widgets via `overlayBuilderMap`

## Key Patterns

### Adding a new game action (e.g., auction, mortgage)

1. Add method to `GameController` (pure logic, no UI dependency)
2. Expose getter in `AppGame` (in `game.dart`) for UI state
3. Add overlay in `main.dart` `overlayBuilderMap`
4. Call controller method from overlay callback

### Adding a new tile type

1. Add enum value to `TileType` in `tile.dart`
2. Add tile data in `board_data.dart`
3. Handle the type in `GameController` methods
4. Handle rendering in `BoardView`
5. Handle in `AppGame._checkCurrentTile()`

### Turn flow sequence

```
rollDice()
  → _executeRoll()
    → moveCurrentPlayer()
    → addGoMoney() if passed GO
    → _checkCurrentTile()
      → buy/skip dialog (property)
      → draw card (chance/community)
      → pay rent (owned)
      → pay tax
      → go to jail
    → _afterTileAction()
      → building (if monopoly)
      → doubles (extra turn)
      → _endTurn()
```

## Common Pitfalls

- `$` trong Dart string literal phải escape: dùng `\$` thay vì `$`
- Flame Canvas không có hit-testing mặc định — dùng Flutter overlay cho UI tương tác
- `GameController` dùng `List<Tile>` deep copy từ `standardMonopolyTiles` — không mutate global data
- `onGameResize` gọi trước `onLoad` — không truy cập late fields trong resize handler

## Running

```bash
flutter analyze
flutter run -d chrome
flutter run -d windows
```

## Related Files

- `docs/architecture.md` — Chi tiết kiến trúc
- `docs/features.md` — Danh sách tính năng
- `docs/roadmap.md` — Roadmap phát triển
