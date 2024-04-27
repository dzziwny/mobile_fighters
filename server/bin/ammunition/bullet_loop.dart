import 'package:core/core.dart';

import '../game.dart';
import 'ammunition_loop.dart';

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

var bulletsLoop = getBulletLoop();

BulletsLoop getBulletLoop() => BulletsLoop(
      ammunitionPerPlayer: gameSettings.maxBullePerPlayer,
      currentAmmo: currentBullets,
      magazine: bullets,
      cooldown: Duration(milliseconds: gameSettings.bulletsCooldown),
      initVelocity: gameSettings.bulletVelocity,
    );
