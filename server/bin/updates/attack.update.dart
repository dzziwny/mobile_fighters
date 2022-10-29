import 'dart:math';
import 'dart:typed_data';

import '../setup.dart';

void attackUpdate(List<int> data) {
  final attackingPlayerId = data[0];
  final targets = Map<int, List<double>>.from(playerPositions);
  final attackingPosition = targets.remove(attackingPlayerId);
  if (attackingPosition == null) {
    return;
  }

  final attackingPoint = Point(attackingPosition[0], attackingPosition[1]);
  for (var entry in targets.entries) {
    final targetId = entry.key;
    final targetPosition = entry.value;

    final isHit =
        isInAttackArea(attackingPoint, attackingPosition[2], targetPosition);
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

  final x = attackingPosition[0];
  final y = attackingPosition[1];
  final angle = attackingPosition[2];
  final frame = <int>[
    attackingPlayerId,
    ...(ByteData(4)..setFloat32(0, x)).buffer.asUint8List(),
    ...(ByteData(4)..setFloat32(0, y)).buffer.asUint8List(),
    ...(ByteData(4)..setFloat32(0, angle)).buffer.asUint8List(),
  ];

  gameDraws.add((() {
    for (var channel in attackWSChannels) {
      channel.sink.add(frame);
    }
  }));
}

bool isInAttackArea(
    Point a, double attackingPlayerAngle, List<double> targetPosition) {
  final playerX = targetPosition[0];
  final playerY = targetPosition[1];

  final p = Point(playerX, playerY);
  const r = 150.0;
  const angle = pi / 6;
  final dx1 = r * sin(attackingPlayerAngle - angle);
  final dy1 = r * cos(attackingPlayerAngle - angle);

  final x1 = a.x + dx1;
  final y1 = a.y - dy1;

  final b = Point(x1, y1);

  final dx2 = r * sin(attackingPlayerAngle + angle);
  final dy2 = r * cos(attackingPlayerAngle + angle);

  final x2 = a.x + dx2;
  final y2 = a.y - dy2;

  final c = Point(x2, y2);
  var A =
      1 / 2 * (-b.y * c.x + a.y * (-b.x + c.x) + a.x * (b.y - c.y) + b.x * c.y);
  var sign = A < 0 ? -1 : 1;
  var s =
      (a.y * c.x - a.x * c.y + (c.y - a.y) * p.x + (a.x - c.x) * p.y) * sign;
  var t =
      (a.x * b.y - a.y * b.x + (a.y - b.y) * p.x + (b.x - a.x) * p.y) * sign;

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
  playerPositions.remove(playerId);
  playerKnobs.remove(playerId);
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
