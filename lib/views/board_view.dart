import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../controllers/game_controller.dart';

class BoardView extends PositionComponent {
  final GameController gameController;

  BoardView({required this.gameController});

  List<Rect>? _tileRects;
  final double _padding = 20.0;
  double _tileWidth = 0;
  double _tileHeight = 0;

  static const _playerColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
  ];

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    _calcRects();

    final bgPaint = Paint()..color = const Color(0xFF8FBC8F);
    canvas.drawRect(Rect.fromLTWH(0, 0, size.x, size.y), bgPaint);

    for (int i = 0; i < _tileRects!.length; i++) {
      _drawTile(canvas, i);
    }

    _drawPlayers(canvas);
  }

  void _calcRects() {
    if (_tileRects != null) return;
    final boardSize = size;
    _tileWidth = (boardSize.x - 2 * _padding) / 10;
    _tileHeight = (boardSize.y - 2 * _padding) / 10;
    _tileRects = List.generate(40, (index) {
      double left, top;
      if (index < 10) {
        left = _padding + index * _tileWidth;
        top = boardSize.y - _padding - _tileHeight;
      } else if (index < 20) {
        left = boardSize.x - _padding - _tileWidth;
        top = _padding + (index - 10) * _tileHeight;
      } else if (index < 30) {
        left = boardSize.x - _padding - ((index - 20) + 1) * _tileWidth;
        top = _padding;
      } else {
        left = _padding;
        top = _padding + (index - 30) * _tileHeight;
      }
      return Rect.fromLTWH(left, top, _tileWidth, _tileHeight);
    });
  }

  void _drawTile(Canvas canvas, int index) {
    final rect = _tileRects![index];
    final tile = gameController.boardTiles[index];

    final fillPaint = Paint()..style = PaintingStyle.fill;
    if (tile.groupColor != null) {
      fillPaint.color = Color(tile.groupColor!).withValues(alpha: 0.2);
    } else {
      fillPaint.color = Colors.white;
    }
    canvas.drawRect(rect, fillPaint);

    if (tile.isOwned) {
      final ownerPaint = Paint()
        ..color = _playerColors[tile.ownerIndex % _playerColors.length]
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4;
      canvas.drawRect(rect, ownerPaint);
    }

    // Draw color band on top edge for properties
    if (tile.groupColor != null) {
      final bandPaint = Paint()
        ..color = Color(tile.groupColor!)
        ..style = PaintingStyle.fill;
      final bandHeight = _tileHeight * 0.15;
      if (index < 10) {
        canvas.drawRect(Rect.fromLTWH(rect.left, rect.top, _tileWidth, bandHeight), bandPaint);
      } else if (index < 20) {
        canvas.drawRect(Rect.fromLTWH(rect.right - bandHeight, rect.top, bandHeight, _tileHeight), bandPaint);
      } else if (index < 30) {
        canvas.drawRect(Rect.fromLTWH(rect.left, rect.bottom - bandHeight, _tileWidth, bandHeight), bandPaint);
      } else {
        canvas.drawRect(Rect.fromLTWH(rect.left, rect.top, bandHeight, _tileHeight), bandPaint);
      }
    }

    // Draw houses
    if (tile.houses > 0) {
      final housePaint = Paint()
        ..color = tile.houses == 5 ? Colors.red : Colors.green
        ..style = PaintingStyle.fill;
      final size = _tileWidth < _tileHeight ? _tileWidth : _tileHeight;
      final dotSize = size * 0.08;
      for (int h = 0; h < (tile.houses == 5 ? 1 : tile.houses); h++) {
        final dx = rect.left + _tileWidth * 0.65 + h * (dotSize * 1.2);
        final dy = rect.top + _tileHeight * 0.1;
        canvas.drawCircle(Offset(dx, dy), dotSize, housePaint);
      }
      if (tile.houses == 5) {
        final labelPaint = TextPaint(
          style: const TextStyle(fontSize: 8, color: Colors.white),
        );
        labelPaint.render(canvas, 'H', Vector2(
          rect.left + _tileWidth * 0.65 - 3,
          rect.top + _tileHeight * 0.1 - 4,
        ));
      }
    }

    final borderPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;
    canvas.drawRect(rect, borderPaint);

    if (tile.name.isNotEmpty) {
      final textPaint = TextPaint(
        style: const TextStyle(fontSize: 9, color: Colors.black),
      );
      textPaint.render(canvas, tile.name, Vector2(rect.left + 2, rect.top + 4));
      if (tile.price != null) {
        final pricePaint = TextPaint(
          style: const TextStyle(fontSize: 8, color: Colors.grey),
        );
        pricePaint.render(canvas, '\$${tile.price}', Vector2(rect.left + 2, rect.bottom - 14));
      }
    }
  }

  void _drawPlayers(Canvas canvas) {
    final players = gameController.activePlayers;
    for (int i = 0; i < players.length; i++) {
      final player = players[i];
      if (player.position < 0 || player.position >= 40) continue;
      final tileRect = _tileRects![player.position];
      final centerX = tileRect.left + _tileWidth / 2;
      final centerY = tileRect.top + _tileHeight / 2;
      final radius = (_tileWidth < _tileHeight ? _tileWidth : _tileHeight) * 0.25;
      final paint = Paint()
        ..color = _playerColors[i % _playerColors.length]
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(centerX, centerY), radius, paint);
    }
  }
}
