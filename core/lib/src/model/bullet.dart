import 'package:vector_math/vector_math.dart';

class Bullet {
  final int id;
  final int shooter;
  final Vector2 velocity;
  final double angle;
  Vector2 position;

  Bullet({
    required this.id,
    required this.shooter,
    required this.velocity,
    required this.angle,
    required this.position,
  });
}
