import 'dart:async';
import 'dart:math';

import 'package:core/core.dart';
import 'package:synchronized/synchronized.dart';
import 'package:vector_math/vector_math.dart';

import '../model/player_physics.dart';
import '../setup.dart';

var _attackIdLock = Lock();
final _bits = List<int>.generate(256, (i) => i);
final _idsInUsage = <int, bool>{};

Future<int> _generateAttackId() => _attackIdLock.synchronized(() {
      for (var id in _bits) {
        if (_idsInUsage[id] != null) {
          continue;
        }

        _idsInUsage[id] = true;
        return id;
      }

      throw Exception('Attacks stack overflow xd');
    });

Future<void> _releaseAttackId(int id) => _attackIdLock.synchronized(() {
      _idsInUsage.remove(id);
    });

void attackUpdate(int attackerId) async {
  final physic = playerPhysics[attackerId];
  if (physic == null) {
    return;
  }

  final attackId = await _generateAttackId();
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
    final targetPlayer = players[targetId];
    if (targetPlayer == null) {
      return;
    }

    final isHit = targetPosition.distanceToSquared(attackCenter) <
        attackAreaRadiusSquared;
    if (isHit) {
      final hitPlayer = targetPlayer.copyWith(hp: targetPlayer.hp - 40);
      players[targetId] = hitPlayer;
      if (hitPlayer.hp <= 0) {
        handlePlayerDead(targetId, attackerId);
      } else {
        drawPlayerHit(targetId, hitPlayer.hp);
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
    _releaseAttackId(attackId);
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
  final dto = HitDto(hp: hp, playerId: playerId);
  final bytes = dto.toBytes();
  gameDraws.add(() {
    for (var channel in hitWSChannels) {
      channel.sink.add(bytes);
    }
  });
}

void handlePlayerDead(int playerId, int attackingPlayerId) {
  _sharePlayerDead(playerId, attackingPlayerId);
  final physic = playerPhysics[playerId];
  final player = players[playerId];
  if (physic == null || player == null) {
    return;
  }

  // recreate player
  final randomX = Random().nextInt((frameWidth).toInt()).toDouble();
  final randomY = Random().nextInt((frameHeight).toInt()).toDouble();
  final randomAngle = Random().nextInt(100) / 10.0;
  physic.position = Vector2(randomX, randomY);
  physic.angle = randomAngle;

  final position = Position(
    playerId: playerId,
    x: randomX,
    y: randomY,
    angle: randomAngle,
  );
  final hitPlayer = player.copyWith(hp: 200, position: position);
  players[playerId] = hitPlayer;

  sharePlayers();

  // share new position
  final data = <int>[
    playerId,
    ...physic.position.x.toBytes(),
    ...physic.position.y.toBytes(),
    ...physic.angle.toBytes(),
  ];

  gameDraws.add(() {
    for (var channel in pushChannels) {
      channel.sink.add(data);
    }
  });

  // share new hp
  drawPlayerHit(playerId, hitPlayer.hp);
}

void _sharePlayerDead(int playerId, int attackingPlayerId) {
  final channel = deadWSChannels[playerId];
  if (channel == null) {
    return;
  }

  channel.sink.add([attackingPlayerId]);
}
