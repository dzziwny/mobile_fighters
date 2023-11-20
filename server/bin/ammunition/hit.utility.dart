import 'dart:math';

import 'package:core/core.dart';
import 'package:vector_math/vector_math.dart';

import '../setup.dart';

Player? isHit(Ammunition ammo, double hitDistance) {
  for (var i = 0; i < maxPlayers; i++) {
    if (i == ammo.shooterId) {
      continue;
    }

    final physic = players[i];
    final distance = ammo.position.distanceToSquared(
      Vector2(
        physic.x.toDouble(),
        physic.y.toDouble(),
      ),
    );

    if (distance < hitDistance) {
      return physic;
    }
  }

  return null;
}

void hitPlayer(
  Ammunition ammo,
  Player physic,
  int targetId,
  int power,
) async {
  final targetPlayer = players[targetId];
  targetPlayer.hp = targetPlayer.hp - power;
  if (targetPlayer.hp <= 0) {
    handlePlayerDead(targetId, ammo.shooterId);
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
    ..isBombCooldownBit = 0
    ..isDashCooldownBit = 0;

  shareGameData();
}
