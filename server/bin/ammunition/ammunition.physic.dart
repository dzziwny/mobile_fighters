import 'package:core/core.dart';
import 'package:vector_math/vector_math.dart';

import 'hit.utility.dart';

void ammunitionPhysicUpdate({
  required Ammunition ammo,
  required double dt,
  required double hitDistance,
  required double maxDistance,
  required int power,
}) {
  final velocityUpdate = ammo.velocity * dt;
  final newPosition = ammo.position + velocityUpdate;
  if (_isOutOfBound(newPosition)) {
    ammo.reset();
    return;
  }

  final distance = ammo.startPosition.distanceToSquared(newPosition);
  if (distance > maxDistance) {
    ammo.reset();
    return;
  }

  final player = isHit(ammo, hitDistance);
  if (player != null) {
    hitPlayer(ammo, player, player.id, power);
    ammo.reset();
    return;
  }

  ammo.position = newPosition;
}

bool _isOutOfBound(Vector2 position) {
  return position.x < battleGroundStartX ||
      position.x > battleGroundEndX ||
      position.y < battleGroundStartY ||
      position.y > battleGroundEndY;
}
