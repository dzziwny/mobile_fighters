import 'package:core/core.dart';

import 'actions/create_bomb.action.dart';
import 'actions/create_bullet.action.dart';
import 'setup.dart';

Future<void> bulletPhysicUpdate(Bullet bullet, double dt) async {
  final position = bullet.position + bullet.velocity * dt;
  if (position.x < 0.0 ||
      position.x > boardWidth ||
      position.y < 0.0 ||
      position.y > boardHeight) {
    return await _removeBullet(bullet);
  }

  final distance = bullet.startPosition.distanceToSquared(position);
  if (distance > 100000.0) {
    return await _removeBullet(bullet);
  }

  final hitPlayer = _isHit(bullet);
  if (hitPlayer != null) {
    await Future.wait([
      _hitPlayer(bullet, hitPlayer.value, hitPlayer.key),
      _removeBullet(bullet),
    ]);

    return;
  }

  bullet.position = position;
}

MapEntry<int, PlayerPhysics>? _isHit(Bullet bullet) {
  final physics = {...playerPhysics}..remove(bullet.shooterId);
  for (var entry in physics.entries) {
    final physic = entry.value;
    if (bullet.position.distanceToSquared(physic.position) < 1000) {
      return entry;
    }
  }

  return null;
}

Future<void> _hitPlayer(
  Bullet bullet,
  PlayerPhysics physic,
  int targetId,
) async {
  final targetPlayer = players[targetId];
  if (targetPlayer == null) {
    return;
  }

  final hitPlayer = targetPlayer.copyWith(
    hp: targetPlayer.hp - bulletPower,
  );

  players[targetId] = hitPlayer;
  if (hitPlayer.hp <= 0) {
    handlePlayerDead(targetId, bullet.shooterId);
  } else {
    drawPlayerHit(targetId, hitPlayer.hp);
  }
}

Future<void> _removeBullet(Bullet bullet) async {
  await releaseBulletId(bullet.id);
  bullets.remove(bullet.id);
}
