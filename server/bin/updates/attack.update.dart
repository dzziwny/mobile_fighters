import 'dart:math';
import 'dart:typed_data';

import 'package:vector_math/vector_math.dart';

import '../model/player_physics.dart';
import '../setup.dart';

void attackUpdate(List<int> data) {
  final attackingPlayerId = data[0];
  final targets = Map<int, PlayerPhysics>.from(playerPhysics);
  final attackPhysic = targets.remove(attackingPlayerId);
  if (attackPhysic == null) {
    return;
  }

  for (var entry in targets.entries) {
    final targetId = entry.key;
    final targetPosition = entry.value.position;

    final isHit = isInAttackArea(
      attackPhysic.position,
      attackPhysic.angle,
      targetPosition,
    );
    if (isHit) {
      final hp = playerHp[targetId]! - 20;
      playerHp[targetId] = hp;
      if (hp <= 0) {
        handlePlayerDead(targetId, attackingPlayerId);
      } else {
        drawPlayerHit(targetId, hp);
      }
    }
  }

  final position = attackPhysic.position;
  final angle = attackPhysic.angle;
  final frame = <int>[
    attackingPlayerId,
    ...(ByteData(4)..setFloat32(0, position.x)).buffer.asUint8List(),
    ...(ByteData(4)..setFloat32(0, position.y)).buffer.asUint8List(),
    ...(ByteData(4)..setFloat32(0, angle)).buffer.asUint8List(),
  ];

  gameDraws.add((() {
    for (var channel in attackWSChannels) {
      channel.sink.add(frame);
    }
  }));
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
