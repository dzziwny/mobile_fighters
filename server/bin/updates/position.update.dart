import 'dart:math';

import 'package:core/core.dart';
import 'package:vector_math/vector_math.dart';

import '../inputs/player_state_input.dart';
import '../setup.dart';

double _resolveX(Player player, double dt, Vector2 momentum) {
  if (momentum.isNaN) {
    return 0.0;
  }
  var x = player.x + momentum.x * dt;
  if (x > boardWidthDouble) {
    return boardWidthDouble;
  }

  if (x < 0.0) {
    return 0.0;
  }

  return x;
}

double _resolveY(Player physic, double dt, Vector2 force) {
  if (force.isNaN) {
    return 0.0;
  }

  var y = physic.y + force.y * dt;
  if (y > boardHeightDouble) {
    return boardHeightDouble;
  }

  if (y < 0.0) {
    return 0.0;
  }

  return y;
}

int lastX = 0;

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
  if (player.y == boardHeight || player.y == 0.0) {
    player.velocityY = -player.velocityY;
  }
  if (player.x == boardWidth || player.x == 0.0) {
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
