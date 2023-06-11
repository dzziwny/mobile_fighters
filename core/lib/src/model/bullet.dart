import 'package:vector_math/vector_math.dart';

class Bullet {
  final int id;
  final int shooterId;
  final Vector2 velocity;
  final double angle;
  final Vector2 startPosition;
  Vector2 position;

  Bullet({
    required this.id,
    required this.shooterId,
    required this.velocity,
    required this.angle,
    required this.position,
  }) : startPosition = position;
}
