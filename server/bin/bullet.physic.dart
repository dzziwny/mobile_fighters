import 'dart:math';

import 'package:core/core.dart';
import 'package:vector_math/vector_math.dart';

import 'actions/bomb_actions.dart';
import 'setup.dart';

void createBullet(int bulletId, int playerId) {
  final player = players[playerId];
  final velocity = Vector2(sin(player.angle), -cos(player.angle)).normalized()
    ..scale(initBulletScale);

  final position = Vector2(player.x, player.y);
  bullets[bulletId]
    ..shooterId = playerId
    ..velocity = velocity
    ..angle = player.angle
    ..startPosition = position
    ..position = position;
}

void bulletPhysicUpdate(Bullet bullet, double dt) {
  final velocityUpdate = bullet.velocity * dt;
  final position = bullet.position + velocityUpdate;
  if (position.x < 0.0 ||
      position.x > boardWidth ||
      position.y < 0.0 ||
      position.y > boardHeight) {
    bullets[bullet.id].isActive = false;
    return;
  }

  final distance = bullet.startPosition.distanceToSquared(position);
  if (distance > 100000.0) {
    bullets[bullet.id].isActive = false;
    return;
  }

  final player = _isHit(bullet);
  if (player != null) {
    _hitPlayer(bullet, player, player.id);
    bullets[bullet.id].isActive = false;
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
    if (bullet.position.distanceToSquared(
          Vector2(
            physic.x.toDouble(),
            physic.y.toDouble(),
          ),
        ) <
        bombRange) {
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
