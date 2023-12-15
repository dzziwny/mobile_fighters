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

  if (player.isDashActive) {
    _calculateDashPosition(player, state);
  } else {
    _calculatePosition(player, state);
  }
}

void _calculateDashPosition(Player player, PlayerControlsState state) {
  final normalizedInput =
      Vector2(state.inputForceX, state.inputForceY).normalized();

  var x = player.x + normalizedInput.x * gameSettings.dashForceRatio;
  if (x > gameSettings.battleGroundEndX) {
    x = gameSettings.battleGroundEndX;
  } else if (x < gameSettings.battleGroundStartX) {
    x = gameSettings.battleGroundStartX;
  }

  var y = player.y + normalizedInput.y * gameSettings.dashForceRatio;
  if (y > gameSettings.battleGroundEndY) {
    y = gameSettings.battleGroundEndY;
  } else if (y < gameSettings.battleGroundStartY) {
    y = gameSettings.battleGroundStartY;
  }

  player
    ..x = x
    ..y = y
    ..angle = state.angle;
}

void _calculatePosition(Player player, PlayerControlsState state) {
  final dt = gameSettings.sliceTimeSeconds;
  final velocity = Vector2(player.velocityX, player.velocityY);
  final friction = _calculateFriction(player, velocity);
  final netForce = Vector2(state.inputForceX, state.inputForceY) + friction;
  final netVelocity = velocity..add(netForce);

  player
    ..velocityX = netVelocity.x
    ..velocityY = netVelocity.y
    ..x = _resolveX(player, dt, netVelocity)
    ..y = _resolveY(player, dt, netVelocity)
    ..angle = state.angle;

  /// Boundary bouncing
  if (player.y == gameSettings.battleGroundStartY ||
      player.y == gameSettings.battleGroundEndY) {
    player.velocityY = -player.velocityY;
  }
  if (player.x == gameSettings.battleGroundStartX ||
      player.x == gameSettings.battleGroundEndX) {
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
    return gameSettings.battleGroundStartX;
  }

  var x = player.x + momentum.x * dt;
  if (x > gameSettings.battleGroundEndX) {
    return gameSettings.battleGroundEndX;
  }

  if (x < gameSettings.battleGroundStartX) {
    return gameSettings.battleGroundStartX;
  }

  return x;
}

double _resolveY(Player physic, double dt, Vector2 force) {
  // TODO co to jest xd ???

  if (force.isNaN) {
    return gameSettings.battleGroundStartY;
  }

  var y = physic.y + force.y * dt;
  if (y > gameSettings.battleGroundEndY) {
    return gameSettings.battleGroundEndY;
  }

  if (y < gameSettings.battleGroundStartY) {
    return gameSettings.battleGroundStartY;
  }

  return y;
}
