import 'package:core/core.dart';

import 'ammunition_loop.dart';

class BulletsLoop extends AmmunitionCooldown<Bullet> {
  BulletsLoop({
    required super.ammunitionPerPlayer,
    required super.cooldown,
    required super.initVelocity,
  });

  @override
  void onCooldownEnd(int playerId) {}

  @override
  List<Bullet> get magazine => game.bullets;

  @override
  List<int> get currentAmmo => game.currentBullets;
}

var bulletsLoop = getBulletLoop();

BulletsLoop getBulletLoop() => BulletsLoop(
      ammunitionPerPlayer: gameSettings.maxBullePerPlayer,
      cooldown: Duration(milliseconds: gameSettings.bulletsCooldown),
      initVelocity: gameSettings.bulletVelocity,
    );
