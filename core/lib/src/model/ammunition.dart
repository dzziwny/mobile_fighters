import 'package:vector_math/vector_math.dart';

abstract class Ammunition {
  int shooterId;
  double angle;
  Vector2 startPosition;
  Vector2 position;
  Vector2 velocity;

  Ammunition({
    required this.shooterId,
    required this.angle,
    required this.startPosition,
    required this.position,
    required this.velocity,
  });

  void reset() {
    position = Vector2.zero();
    velocity = Vector2.zero();
  }
}
