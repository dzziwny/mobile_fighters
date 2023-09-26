import 'dart:async';
import 'dart:math';

import 'package:core/core.dart';
import 'package:vector_math/vector_math.dart';

import '../setup.dart';

void createBomb(int playerId) async {
  final player = players[playerId];

  double x = attackLength * sin(player.angle);
  double y = -attackLength * cos(player.angle);
  final target = Vector2(x + player.x, y + player.y);

  Timer(attackUntilBoomDuration, () {
    explodeBomb(playerId, target);
  });

  final response = Bomb(
    id: playerId,
    position: Vector2(player.x, player.y),
    target: Vector2(target.x, target.y),
    velocity: Vector2(sin(player.angle), -cos(player.angle)).normalized()
      ..scale(initBombScale),
  );

  bombs.add(response);
}

void explodeBomb(
  int bombId,
  Vector2 attackCenter,
) {
  for (var id = 0; id < maxPlayers; id++) {
    final target = players[id];
    final targetPosition = Vector2(target.x.toDouble(), target.y.toDouble());
    final isHit = targetPosition.distanceToSquared(attackCenter) <
        attackAreaRadiusSquared;
    if (isHit) {
      target.hp = target.hp - bombPower;
      if (target.hp <= 0) {
        handlePlayerDead(id, bombId);
      } else {
        drawPlayerHit(id, target.hp);
      }
    }
  }

  final response = Bomb.empty(bombId);

  bombs.add(response);
}

void handlePlayerDead(int enemyId, int killerId) {
  frags[killerId] |= Bits.frags[enemyId];
  final player = players[enemyId];
  final playerMetadata = playerMetadatas[enemyId];

  // recreate player
  var respawnX = Random().nextInt((respawnWidth).toInt());
  if (playerMetadata.team == Team.red) {
    respawnX = boardWidth - respawnX;
  }
  final randomY = Random().nextInt((boardHeight).toInt());
  final randomAngle = Random().nextInt(100) / 10.0;
  player
    ..x = respawnX.toDouble()
    ..y = randomY.toDouble()
    ..angle = randomAngle
    ..hp = startHpDouble
    ..isBombCooldown = 0
    ..isDashCooldown = 0;

  shareGameData();

  // share new hp after respawn
  drawPlayerHit(enemyId, player.hp);
}

void drawPlayerHit(int playerId, double hp) {
  hits[playerId].hp = hp;
}
