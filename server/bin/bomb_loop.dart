import 'package:core/core.dart';

import 'amunition_loop.dart';
import 'setup.dart';

class BombLoop extends AmmunitionLoop<Bomb> {
  BombLoop({
    required super.ammunitionPerPlayer,
    required super.magazine,
    required super.currentAmmo,
    required super.cooldown,
    required super.initVelocity,
  });
}

final bombsLoop = BombLoop(
  ammunitionPerPlayer: maxBombsPerPlayer,
  currentAmmo: currentBombs,
  magazine: bombs,
  cooldown: bombCooldown,
  initVelocity: initBombVelocity,
);
