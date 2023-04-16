import 'package:vector_math/vector_math.dart';

class Knob {
  final double x;
  final double y;
  final double angle;

  final Vector2 force;

  Knob(this.x, this.y, this.angle) : force = Vector2(x, y);
}
