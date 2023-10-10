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
    bombs[bomb.id].isActive = false;
    return;
  }

  final distance = bomb.startPosition.distanceToSquared(position);
  if (distance > bombDistanceSquare) {
    bombs[bomb.id].isActive = false;
    return;
  }

  final player = _isHit(bomb);
  if (player != null) {
    _hitPlayer(bomb, player, player.id);
    bombs[bomb.id].isActive = false;
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
    drawPlayerHit(targetId, targetPlayer.hp);
  }
}

// void createBomb(int bombId, int playerId) async {
//   final player = players[playerId];

//   double x = attackLength * sin(player.angle);
//   double y = -attackLength * cos(player.angle);
//   final target = Vector2(x + player.x, y + player.y);

//   Timer(attackUntilBoomDuration, () {
//     explodeBomb(playerId, target);
//   });

//   final response = Bomb(
//     id: playerId,
//     position: Vector2(player.x, player.y),
//     target: Vector2(target.x, target.y),
//     velocity: Vector2(sin(player.angle), -cos(player.angle)).normalized()
//       ..scale(initBombScale),
//     isActive: true,
//   );

//   bombs.add(response);
// }

// void explodeBomb(
//   int bombId,
//   Vector2 attackCenter,
// ) {
//   for (var id = 0; id < maxPlayers; id++) {
//     final target = players[id];
//     final targetPosition = Vector2(target.x.toDouble(), target.y.toDouble());
//     final isHit = targetPosition.distanceToSquared(attackCenter) <
//         attackAreaRadiusSquared;
//     if (isHit) {
//       target.hp = target.hp - bombPower;
//       if (target.hp <= 0) {
//         handlePlayerDead(id, bombId);
//       } else {
//         drawPlayerHit(id, target.hp);
//       }
//     }
//   }

//   final response = Bomb.empty(bombId);

//   bombs.add(response);
// }

void handlePlayerDead(int enemyId, int killerId) {
  frags[killerId] |= Bits.frags[enemyId];
  final player = players[enemyId];
  final playerMetadata = playerMetadatas[enemyId];

  // recreate player
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

  // share new hp after respawn
  drawPlayerHit(enemyId, player.hp);
}

void drawPlayerHit(int playerId, double hp) {
  hits[playerId].hp = hp;
}
