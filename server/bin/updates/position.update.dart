import 'dart:math';
import 'dart:typed_data';

import 'package:vector_math/vector_math.dart';

import '../model/player_physics.dart';
import '../setup.dart';

double _resolveX(PlayerPhysics physic, double dt, Vector2 momentum) {
  if (momentum.isNaN) {
    return 0.0;
  }
  var x = physic.position.x + momentum.x * dt;
  if (x > frameWidth) {
    return frameWidth;
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
  if (y > frameHeight) {
    return frameHeight;
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

void physicUpdate(int playerId) {
  const dt = sliceTimeSeconds;
  final physic = playerPhysics[playerId];
  if (physic == null ||
      (physic.pushingForce.x == 0.0 &&
          physic.pushingForce.y == 0.0 &&
          physic.velocity.x == 0.0 &&
          physic.velocity.y == 0.0)) {
    return;
  }

  final friction = calculateFriction(physic);
  final netForce = physic.pushingForce + friction;

  physic.velocity
    ..add(netForce)
    ..roundToZero();
  physic.position = _resolvePosition(physic, dt);

  /// Boundary bouncing
  if (physic.position.y == frameHeight || physic.position.y == 0.0) {
    physic.velocity.y = -physic.velocity.y;
  }
  if (physic.position.x == frameWidth || physic.position.x == 0.0) {
    physic.velocity.x = -physic.velocity.x;
  }

  final data = <int>[
    playerId,
    ...(ByteData(4)..setFloat32(0, physic.position.x)).buffer.asUint8List(),
    ...(ByteData(4)..setFloat32(0, physic.position.y)).buffer.asUint8List(),
    ...(ByteData(4)..setFloat32(0, physic.angle)).buffer.asUint8List(),
  ];

  gameDraws.add(() {
    for (var channel in pushChannels) {
      channel.sink.add(data);
    }
  });
}

Vector2 calculateFriction(PlayerPhysics physics) {
  final scale = -physics.k * pow(physics.velocity.length2, physics.n);
  return physics.velocity.normalized().scaled(scale);
}
