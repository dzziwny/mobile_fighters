import 'dart:async';
import 'dart:math';

import 'package:core/core.dart';
import 'package:vector_math/vector_math.dart';

import '../model/player_physics.dart';
import '../setup.dart';

void attackUpdate(int attackerId) {
  final physic = playerPhysics[attackerId];
  if (physic == null) {
    return;
  }

  final target = calculateTarget(physic);
  Timer(attackDelay, () {
    gameUpdates.add(() => _completeAttackUpdate(attackerId, target));
  });

  final response = StartAttackResponse(attackerId, target.x, target.y);
  final bytes = response.toBytes();

  gameDraws.add((() {
    for (var channel in attackWSChannels) {
      channel.sink.add(bytes);
    }
  }));
}

void _completeAttackUpdate(int attackerId, Vector2 attackCenter) {
  // final targets = Map<int, PlayerPhysics>.from(playerPhysics);
  // final physic = targets.remove(attackerId);

  for (final entry in playerPhysics.entries) {
    final targetId = entry.key;
    final targetPosition = entry.value.position;

    final isHit =
        targetPosition.distanceToSquared(attackCenter) < attackRangeSquared;
    if (isHit) {
      final hp = playerHp[targetId]! - 20;
      playerHp[targetId] = hp;
      if (hp <= 0) {
        // TODO dont remove position from playerPhysics
        // handlePlayerDead(targetId, attackerId);
      } else {
        drawPlayerHit(targetId, hp);
      }
    }
  }
}

Vector2 calculateTarget(PlayerPhysics physic) {
  double x = attackLength * sin(physic.angle);
  double y = -attackLength * cos(physic.angle);
  final update = Vector2(x, y);

  final target = physic.position + update;
  return target;
}

bool isInAttackArea(Vector2 attack, double attackAngle, Vector2 target) {
  const r = 150.0;
  const angle = pi / 6;
  final dx1 = r * sin(attackAngle - angle);
  final dy1 = r * cos(attackAngle - angle);

  final x1 = attack.x + dx1;
  final y1 = attack.y - dy1;

  final b = Point(x1, y1);

  final dx2 = r * sin(attackAngle + angle);
  final dy2 = r * cos(attackAngle + angle);

  final x2 = attack.x + dx2;
  final y2 = attack.y - dy2;

  final c = Point(x2, y2);
  var A = 1 /
      2 *
      (-b.y * c.x +
          attack.y * (-b.x + c.x) +
          attack.x * (b.y - c.y) +
          b.x * c.y);
  var sign = A < 0 ? -1 : 1;
  var s = (attack.y * c.x -
          attack.x * c.y +
          (c.y - attack.y) * target.x +
          (attack.x - c.x) * target.y) *
      sign;
  var t = (attack.x * b.y -
          attack.y * b.x +
          (attack.y - b.y) * target.x +
          (b.x - attack.x) * target.y) *
      sign;

  return s > 0 && t > 0 && (s + t) < 2 * A * sign;
}

void drawPlayerHit(int playerId, int hp) {
  final List<int> data = [playerId, hp];
  gameDraws.add(() {
    for (var channel in hitWSChannels) {
      channel.sink.add(data);
    }
  });
}

void handlePlayerDead(int playerId, int attackingPlayerId) {
  playerPhysics.remove(playerId);
  final player = players.remove(playerId);

  sharePlayers();
  if (player != null) {
    sharePlayerRemoved(player);
  }

  _sharePlayerDead(playerId, attackingPlayerId);
}

void _sharePlayerDead(int playerId, int attackingPlayerId) {
  final channel = deadWSChannels[playerId];
  if (channel == null) {
    return;
  }

  channel.sink.add([attackingPlayerId]);
}
