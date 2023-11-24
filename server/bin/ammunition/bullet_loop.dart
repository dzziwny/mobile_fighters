import 'package:core/core.dart';

import 'ammunition_loop.dart';
import '../setup.dart';

class BulletsLoop extends AmmunitionCooldown<Bullet> {
  BulletsLoop({
    required super.ammunitionPerPlayer,
    required super.magazine,
    required super.currentAmmo,
    required super.cooldown,
    required super.initVelocity,
  });

  @override
  void onCooldownEnd(int playerId) {}
}

final bulletsLoop = BulletsLoop(
  ammunitionPerPlayer: maxBullePerPlayer,
  currentAmmo: currentBullets,
  magazine: bullets,
  cooldown: bulletsCooldown,
  initVelocity: initBulletVelocity,
);
