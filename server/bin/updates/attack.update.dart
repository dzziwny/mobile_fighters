import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:vector_math/vector_math.dart';

import '../model/player_physics.dart';
import '../setup.dart';

// TODO
int attackIds = 0;

void attackUpdate(int attackerId) {
  final physic = playerPhysics[attackerId];
  if (physic == null) {
    return;
  }

  final attackId = attackIds++;
  final target = calculateTarget(physic);
  Timer(attackUntilBoomDuration, () {
    gameUpdates.add(() => _completeAttackUpdate(attackId, attackerId, target));
  });

  final response = AttackResponse(
    attackId,
    attackerId,
    target.x,
    target.y,
    AttackPhase.start,
    physic.position.x,
    physic.position.y,
  );

  final bytes = response.toBytes();
  gameDraws.add((() {
    for (var channel in attackWSChannels) {
      channel.sink.add(bytes);
    }
  }));
}

void _completeAttackUpdate(int attackId, int attackerId, Vector2 attackCenter) {
  // final targets = Map<int, PlayerPhysics>.from(playerPhysics);
  // final physic = targets.remove(attackerId);

  for (final entry in playerPhysics.entries) {
    final targetId = entry.key;
    final targetPosition = entry.value.position;

    final isHit = targetPosition.distanceToSquared(attackCenter) <
        attackAreaRadiusSquared;
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

  final response =
      AttackResponse(attackId, 0, .0, .0, AttackPhase.boom, .0, .0);
  final bytes = response.toBytes();
  gameDraws.add((() {
    for (var channel in attackWSChannels) {
      channel.sink.add(bytes);
    }
  }));
}

Vector2 calculateTarget(PlayerPhysics physic) {
  double x = attackLength * sin(physic.angle);
  double y = -attackLength * cos(physic.angle);
  final update = Vector2(x, y);

  final target = physic.position + update;
  return target;
}

void drawPlayerHit(int playerId, int hp) {
  final Uint8List data = [playerId, hp].toBytes();
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
