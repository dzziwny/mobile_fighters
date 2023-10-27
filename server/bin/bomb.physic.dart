import 'dart:math';

import 'package:core/core.dart';
import 'package:vector_math/vector_math.dart';

import 'setup.dart';

void bombPhysicUpdate(Bomb bomb, double dt) {
  final velocityUpdate = bomb.velocity * dt;
  final position = bomb.position + velocityUpdate;
  if (position.x < battleGroundStartX ||
      position.x > battleGroundEndX ||
      position.y < battleGroundStartY ||
      position.y > battleGroundEndY) {
    bomb.reset();
    return;
  }

  final distance = bomb.startPosition.distanceToSquared(position);
  if (distance > bombDistanceSquare) {
    bomb.reset();
    return;
  }

  final player = _isHit(bomb);
  if (player != null) {
    _hitPlayer(bomb, player, player.id);
    bomb.reset();
    return;
  }

  bomb.position = position;
}

Player? _isHit(Bomb bomb) {
  for (var i = 0; i < maxPlayers; i++) {
    if (i == bomb.shooterId) {
      continue;
    }

    final physic = players[i];
    if (bomb.position.distanceToSquared(
          Vector2(
            physic.x.toDouble(),
            physic.y.toDouble(),
          ),
        ) <
        bombPlayerCollisionDistanceSquare) {
      return physic;
    }
  }

  return null;
}

void _hitPlayer(
  Bomb bomb,
  Player physic,
  int targetId,
) async {
  final targetPlayer = players[targetId];
  targetPlayer.hp = targetPlayer.hp - bombPower;
  if (targetPlayer.hp <= 0) {
    handlePlayerDead(targetId, bomb.shooterId);
  } else {
    hits[targetId] = 1;
  }
}

void handlePlayerDead(int enemyId, int killerId) {
  frags[killerId] |= Bits.frags[enemyId];
  final player = players[enemyId];
  final playerMetadata = playerMetadatas[enemyId];

  var respawnX = battleGroundStartX + Random().nextInt(respawnWidth);
  if (playerMetadata.team == Team.red) {
    respawnX = battleGroundEndX - respawnX;
  }
  final respawnY = battleGroundStartY + Random().nextInt(battleGroundHeight);
  final respawnAngle = Random().nextInt(100) / 10.0;
  player
    ..x = respawnX
    ..y = respawnY
    ..angle = respawnAngle
    ..hp = startHp
    ..isBombCooldown = 0
    ..isDashCooldown = 0;

  shareGameData();
}
