import 'package:vector_math/vector_math.dart';

class PlayerPhysics {
  Vector2 position;
  double angle = 0.0;
  Vector2 velocity = Vector2.zero();
  Vector2 pushingForce = Vector2.zero();

  PlayerPhysics(this.position);

  bool isNan() =>
      angle.isNaN || velocity.isNaN || position.isNaN || pushingForce.isNaN;

  bool isInfinite() =>
      angle.isInfinite ||
      velocity.isInfinite ||
      position.isInfinite ||
      pushingForce.isInfinite;
}
