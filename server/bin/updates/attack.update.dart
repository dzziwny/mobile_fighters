import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:core/core.dart';
import 'package:synchronized/synchronized.dart';
import 'package:vector_math/vector_math.dart';

import '../actions/action.dart';
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

Future<void> attackUpdate(int attackerId) async {
  final physic = playerPhysics[attackerId];
  if (physic == null) {
    return;
  }

  final attackId = await _generateAttackId();
  final target = calculateTarget(physic);
  Timer(attackUntilBoomDuration, () {
    actions.add(CompleteAttackAction(attackId, attackerId, target));
  });

  final response = BombAttackResponse(
    attackId,
    attackerId,
    target.x,
    target.y,
    AttackPhase.start,
    physic.position.x,
    physic.position.y,
  );

  bombAttackResponses.add(response);
}

Future<void> completeAttackUpdate(
  int attackId,
  int attackerId,
  Vector2 attackCenter,
) async {
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
      final hitPlayer = targetPlayer.copyWith(
        hp: targetPlayer.hp - attackPower,
      );
      players[targetId] = hitPlayer;
      if (hitPlayer.hp <= 0) {
        handlePlayerDead(targetId, attackerId);
      } else {
        drawPlayerHit(targetId, hitPlayer.hp);
      }
    }
  }

  final response =
      BombAttackResponse(attackId, 0, .0, .0, AttackPhase.boom, .0, .0);
  bombAttackResponses.add(response);
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
  hits.add(dto);
}

void handlePlayerDead(int playerId, int attackingPlayerId) {
  _shareFrag(attackingPlayerId, playerId);
  final physic = playerPhysics[playerId];
  final player = players[playerId];
  if (physic == null || player == null) {
    return;
  }

  // recreate player
  var respawnX = Random().nextInt((respawnWidth).toInt()).toDouble();
  if (player.team == Team.red) {
    respawnX = boardWidth - respawnX;
  }
  final randomY = Random().nextInt((boardHeight).toInt()).toDouble();
  final randomAngle = Random().nextInt(100) / 10.0;
  physic.position = Vector2(respawnX, randomY);
  physic.angle = randomAngle;

  final position = PlayerPosition(
    playerId: playerId,
    x: respawnX,
    y: randomY,
    angle: randomAngle,
  );
  final hitPlayer = player.copyWith(hp: startHp, position: position);
  players[playerId] = hitPlayer;

  sharePlayers();

  // share new hp after respawn
  drawPlayerHit(playerId, hitPlayer.hp);
}

void _shareFrag(int killerId, int enemyId) {
  final killer = players[killerId];
  final enemy = players[enemyId];
  if (killer == null || enemy == null) {
    return;
  }

  final dto = FragDto(
    enemy: enemy.nick,
    enemyTeam: enemy.team,
    killer: killer.nick,
    killerTeam: killer.team,
  );

  final data = jsonEncode(dto);
  for (var channel in fragWSChannels.values) {
    channel.sink.add(data);
  }
}
