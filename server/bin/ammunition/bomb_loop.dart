import 'package:core/core.dart';

import '../game_setup.dart';
import 'ammunition_loop.dart';

class BombLoop extends AmmunitionCooldown<Bomb> {
  BombLoop({
    required super.ammunitionPerPlayer,
    required super.magazine,
    required super.currentAmmo,
    required super.cooldown,
    required super.initVelocity,
  });

  @override
  void onAction(int playerId) {
    super.onAction(playerId);
    setup.players[playerId].isBombCooldownBit = Bits.bombCooldown;
  }

  @override
  void onCooldownEnd(int playerId) {
    setup.players[playerId].isBombCooldownBit = 0;
  }
}

var bombsLoop = getBombLoop();
BombLoop getBombLoop() => BombLoop(
      ammunitionPerPlayer: gameSettings.maxBombsPerPlayer,
      currentAmmo: currentBombs,
      magazine: bombs,
      cooldown: Duration(seconds: gameSettings.bombCooldown),
      initVelocity: gameSettings.bombVelocity,
    );
