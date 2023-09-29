import 'package:core/core.dart';

import 'amunition_loop.dart';
import 'setup.dart';

class BulletsLoop extends AmmunitionLoop<Bullet> {
  BulletsLoop({
    required super.ammunitionPerPlayer,
    required super.magazine,
    required super.currentAmmo,
    required super.cooldown,
    required super.initVelocity,
  });
}

final bulletsLoop = BulletsLoop(
  ammunitionPerPlayer: maxBullePerPlayer,
  currentAmmo: currentBullets,
  magazine: bullets,
  cooldown: bulletsCooldown,
  initVelocity: initBulletVelocity,
);
