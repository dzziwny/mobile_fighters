import 'dart:math';

import 'package:core/core.dart';
import 'package:vector_math/vector_math.dart';

import '../inputs/player_state_input.dart';
import '../setup.dart';

Future<void> playerPhysicUpdate(
  PlayerControlsState state,
) async {
  final player = players[state.playerId];
  if (!player.isActive) {
    return;
  }

  const dt = sliceTimeSeconds;
  final velocity = Vector2(player.velocityX, player.velocityY);
  final friction = _calculateFriction(player, velocity);
  final netForce = Vector2(state.inputForceX, state.inputForceY) + friction;
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

Vector2 _calculateFriction(Player player, Vector2 velocity) {
  final scale = -player.frictionK *
      pow(
        velocity.length2,
        player.frictionN,
      );

  return velocity.normalized().scaled(scale);
}

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
