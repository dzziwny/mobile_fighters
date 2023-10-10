import 'dart:math';

import 'package:core/core.dart';
import 'package:vector_math/vector_math.dart';

import '../inputs/player_state_input.dart';
import '../setup.dart';

double _resolveX(Player player, double dt, Vector2 momentum) {
  // TODO co to jest xd ???
  if (momentum.isNaN) {
    return battleGroundStartX;
  }

  var x = player.x + momentum.x * dt;
  if (x > battleGroundEndX) {
    return battleGroundEndX;
  }

  if (x < battleGroundStartX) {
    return battleGroundStartX;
  }

  return x;
}

double _resolveY(Player physic, double dt, Vector2 force) {
  // TODO co to jest xd ???

  if (force.isNaN) {
    return battleGroundStartY;
  }

  var y = physic.y + force.y * dt;
  if (y > battleGroundEndY) {
    return battleGroundEndY;
  }

  if (y < battleGroundStartY) {
    return battleGroundStartY;
  }

  return y;
}

Future<void> playerPhysicUpdate(
  PlayerControlsState state,
) async {
  const dt = sliceTimeSeconds;
  final player = players[state.playerId];
  final velocity = Vector2(player.velocityX, player.velocityY);
  final friction = calculateFriction(player, velocity);
  final netForce = Vector2(state.x, state.y) + friction;
  final netVelocity = velocity..add(netForce);

  player
    ..velocityX = netVelocity.x
    ..velocityY = netVelocity.y;

  final x = _resolveX(player, dt, netVelocity);
  final y = _resolveY(player, dt, netVelocity);

  final position = Vector2(x, y);
  player
    ..x = position.x
    ..y = position.y
    ..angle = state.angle;

  /// Boundary bouncing
  if (player.y == battleGroundStartY || player.y == battleGroundEndY) {
    player.velocityY = -player.velocityY;
  }
  if (player.x == battleGroundStartX || player.x == battleGroundEndX) {
    player.velocityX = -player.velocityX;
  }
}

Vector2 calculateFriction(Player player, Vector2 velocity) {
  final scale = -gamePhysics.k *
      pow(
        velocity.length2,
        gamePhysics.n,
      );

  return velocity.normalized().scaled(scale);
}
