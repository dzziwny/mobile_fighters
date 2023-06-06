import 'dart:math';

import 'package:core/core.dart';
import 'package:vector_math/vector_math.dart';

import '../setup.dart';

double _resolveX(PlayerPhysics physic, double dt, Vector2 momentum) {
  if (momentum.isNaN) {
    return 0.0;
  }
  var x = physic.position.x + momentum.x * dt;
  if (x > boardWidthDouble) {
    return boardWidthDouble;
  }

  if (x < 0.0) {
    return 0.0;
  }

  return x;
}

double _resolveY(PlayerPhysics physic, double dt, Vector2 momentum) {
  if (momentum.isNaN) {
    return 0.0;
  }

  var y = physic.position.y + momentum.y * dt;
  if (y > boardHeightDouble) {
    return boardHeightDouble;
  }

  if (y < 0.0) {
    return 0.0;
  }

  return y;
}

Vector2 _resolvePosition(PlayerPhysics physic, double dt) {
  final x = _resolveX(physic, dt, physic.velocity);
  final y = _resolveY(physic, dt, physic.velocity);

  final position = Vector2(x, y);
  return position;
}

Future<void> playerPhysicUpdate(
  int playerId,
  double x,
  double y,
  double angle,
) async {
  const dt = sliceTimeSeconds;
  final physic = playerPhysics[playerId];
  if (physic == null) {
    return;
  }

  final friction = calculateFriction(physic);
  final netForce = Vector2(x, y) + friction;

  physic.velocity
    ..add(netForce)
    ..roundToZero();

  physic.position = _resolvePosition(physic, dt);
  physic.angle = angle;

  /// Boundary bouncing
  if (physic.position.y == boardHeight || physic.position.y == 0.0) {
    physic.velocity.y = -physic.velocity.y;
  }
  if (physic.position.x == boardWidth || physic.position.x == 0.0) {
    physic.velocity.x = -physic.velocity.x;
  }
}

Vector2 calculateFriction(PlayerPhysics physics) {
  final scale = -physics.k * pow(physics.velocity.length2, physics.n);
  return physics.velocity.normalized().scaled(scale);
}
