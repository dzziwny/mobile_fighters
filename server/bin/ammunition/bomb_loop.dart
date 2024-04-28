import 'package:core/core.dart';

import 'ammunition_loop.dart';

class BombLoop extends AmmunitionCooldown<Bomb> {
  BombLoop({
    required super.ammunitionPerPlayer,
    required super.cooldown,
    required super.initVelocity,
  });

  @override
  List<Bomb> get magazine => game.bombs;

  @override
  List<int> get currentAmmo => game.currentBombs;

  @override
  void onAction(int playerId) {
    super.onAction(playerId);
    game.players[playerId].isBombCooldownBit = Bits.bombCooldown;
  }

  @override
  void onCooldownEnd(int playerId) {
    game.players[playerId].isBombCooldownBit = 0;
  }
}

var bombsLoop = getBombLoop();
BombLoop getBombLoop() => BombLoop(
      ammunitionPerPlayer: gameSettings.maxBombsPerPlayer,
      cooldown: Duration(seconds: gameSettings.bombCooldown),
      initVelocity: gameSettings.bombVelocity,
    );
