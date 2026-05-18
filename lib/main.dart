import 'package:flutter/material.dart';
import 'package:flutter_application_3/game.dart';
import 'package:flame/game.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    home: GameWidget(
      game: AppGame(),
      overlayBuilderMap: {
        'hud': _buildHUD,
        'buyDialog': _buildBuyDialog,
        'buildDialog': _buildBuildDialog,
        'cardDialog': _buildCardDialog,
        'jailDialog': _buildJailDialog,
        'gameOverDialog': _buildGameOverDialog,
      },
    ),
  ),
);

// --- HUD ---

Widget _buildHUD(BuildContext context, Game game) {
  final appGame = game as AppGame;
  return Stack(
    children: [
      Positioned(
        top: 10,
        left: 0,
        right: 0,
        child: Column(
          children: [
            Text(
              appGame.turnText,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
                backgroundColor: Color(0x80FFFFFF),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 2),
            Text(
              appGame.player1Info,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.red,
                backgroundColor: Color(0x80FFFFFF),
              ),
              textAlign: TextAlign.center,
            ),
            Text(
              appGame.player2Info,
              style: const TextStyle(
                fontSize: 13,
                color: Colors.blue,
                backgroundColor: Color(0x80FFFFFF),
              ),
              textAlign: TextAlign.center,
            ),
            if (appGame.lastMessage.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: const Color(0xBBFFFFFF),
                  child: Text(
                    appGame.lastMessage,
                    style: const TextStyle(fontSize: 13, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
          ],
        ),
      ),
      Positioned(
        bottom: 20,
        left: 0,
        right: 0,
        child: Center(
          child: SizedBox(
            width: 160,
            height: 54,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              onPressed: () => appGame.rollDice(),
              child: const Text('ĐỔ XÚC XẮC'),
            ),
          ),
        ),
      ),
    ],
  );
}

// --- Buy Dialog ---

Widget _buildBuyDialog(BuildContext context, Game game) {
  final appGame = game as AppGame;
  final tileName = appGame.currentTileName;
  final price = appGame.currentTilePrice ?? 0;
  return AlertDialog(
    title: const Text('Mua đất'),
    content: Text('"$tileName"\n\nGiá mua: \$$price\nSố dư: \$${appGame.currentPlayerMoney}'),
    actions: [
      TextButton(onPressed: () => appGame.buyTile(), child: const Text('MUA', style: TextStyle(fontWeight: FontWeight.bold))),
      TextButton(onPressed: () => appGame.skipTile(), child: const Text('BỎ QUA')),
    ],
  );
}

// --- Build Dialog ---

Widget _buildBuildDialog(BuildContext context, Game game) {
  final appGame = game as AppGame;
  final tiles = appGame.buildableTiles;

  return AlertDialog(
    title: const Text('Xây nhà'),
    content: SizedBox(
      width: double.maxFinite,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Chọn ô để xây nhà:'),
          const SizedBox(height: 8),
          ...tiles.map((i) {
            final name = appGame.buildableTilesString.split(', ')[tiles.indexOf(i)];
            final cost = appGame.getHouseCost(i);
            return ListTile(
              title: Text('$name (\$$cost)'),
              dense: true,
              onTap: () => appGame.buyHouse(i),
            );
          }),
        ],
      ),
    ),
    actions: [
      TextButton(onPressed: () => appGame.skipBuild(), child: const Text('BỎ QUA')),
    ],
  );
}

// --- Card Dialog ---

Widget _buildCardDialog(BuildContext context, Game game) {
  final appGame = game as AppGame;
  return AlertDialog(
    title: Text(appGame.statusText.contains('Chance') ? 'Thẻ MAY' : 'Thẻ CỘNG ĐỒNG'),
    content: Text(appGame.lastMessage),
    actions: [
      TextButton(onPressed: () => appGame.executePendingCard(), child: const Text('OK')),
    ],
  );
}

// --- Jail Dialog ---

Widget _buildJailDialog(BuildContext context, Game game) {
  final appGame = game as AppGame;
  return AlertDialog(
    title: const Text('Bạn đang ở TÙ!'),
    content: Text(
      'Số thẻ ra tù: ${appGame.jailFreeCards}\n'
      'Số dư: \$${appGame.currentPlayerMoney}',
    ),
    actions: [
      TextButton(onPressed: () => appGame.jailRollDice(), child: const Text('TUNG XÚC XẮC (ra nếu double)')),
      TextButton(onPressed: () => appGame.jailPayFine(), child: const Text('TRẢ \$50')),
      if (appGame.jailFreeCards > 0)
        TextButton(onPressed: () => appGame.jailUseCard(), child: const Text('DÙNG THẺ RA TÙ')),
    ],
  );
}

// --- Game Over Dialog ---

Widget _buildGameOverDialog(BuildContext context, Game game) {
  final appGame = game as AppGame;
  return AlertDialog(
    title: const Text('TRÒ CHƠI KẾT THÚC!'),
    content: Text(
      '${appGame.winnerName ?? 'Không ai'} chiến thắng!\n\n'
      'Chúc mừng người chiến thắng!',
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
    actions: [
      TextButton(
        onPressed: () => appGame.restartGame(),
        child: const Text('CHƠI LẠI', style: TextStyle(fontSize: 16)),
      ),
    ],
  );
}
