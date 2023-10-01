import 'package:core/core.dart';
import 'package:vector_math/vector_math.dart';

import 'bomb.physic.dart';
import 'setup.dart';

void bulletPhysicUpdate(Bullet bullet, double dt) {
  final velocityUpdate = bullet.velocity * dt;
  final position = bullet.position + velocityUpdate;
  if (position.x < boardStartX ||
      position.x > boardEndX ||
      position.y < boardStartY ||
      position.y > boardEndY) {
    bullets[bullet.id].isActive = false;
    return;
  }

  final distance = bullet.startPosition.distanceToSquared(position);
  if (distance > bulletDistanceSquared) {
    bullets[bullet.id].isActive = false;
    return;
  }

  final player = _isHit(bullet);
  if (player != null) {
    _hitPlayer(bullet, player, player.id);
    bullets[bullet.id].isActive = false;
    bullet.reset();
    return;
  }

  bullet.position = position;
}

Player? _isHit(Bullet bullet) {
  for (var i = 0; i < maxPlayers; i++) {
    if (i == bullet.shooterId) {
      continue;
    }

    final physic = players[i];
    final position = Vector2(
      physic.x.toDouble(),
      physic.y.toDouble(),
    );

    if (bullet.position.distanceToSquared(position) <
        bulletPlayerCollisionDistanceSquare) {
      return physic;
    }
  }

  return null;
}

void _hitPlayer(
  Bullet bullet,
  Player physic,
  int targetId,
) async {
  final targetPlayer = players[targetId];
  targetPlayer.hp = targetPlayer.hp - bulletPower;
  if (targetPlayer.hp <= 0) {
    handlePlayerDead(targetId, bullet.shooterId);
  } else {
    drawPlayerHit(targetId, targetPlayer.hp);
  }
}
