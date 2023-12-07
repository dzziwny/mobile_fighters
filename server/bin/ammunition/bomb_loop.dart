import 'package:core/core.dart';

import 'ammunition_loop.dart';
import '../setup.dart';

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
    players[playerId].isBombCooldownBit = Bits.bombCooldown;
  }

  @override
  void onCooldownEnd(int playerId) {
    players[playerId].isBombCooldownBit = 0;
  }
}

final bombsLoop = BombLoop(
  ammunitionPerPlayer: gameSettings.maxBombsPerPlayer,
  currentAmmo: currentBombs,
  magazine: bombs,
  cooldown: Duration(seconds: gameSettings.bombCooldown),
  initVelocity: gameSettings.initBombVelocity,
);
