import 'package:vector_math/vector_math.dart';

class PlayerPhysics {
  Vector2 position;
  double angle = 0.0;
  Vector2 velocity = Vector2.zero();

  /// Proportionality constant that relates the friction force to the velocity
  /// of the object. Its value is determined by the properties of the materials
  /// in contact, such as the surface roughness, and the density of the fluid
  /// or gas
  double k = 0.1;

  /// depends on the nature of the surfaces in contact, and it can be different
  /// for different materials. For example, when an object moves through a
  /// fluid, the value of "n" can be different for laminar and turbulent
  /// flows. Also can be different for different types of materials,
  /// such as rubber or steel.
  double n = 0.25;

  PlayerPhysics(this.position);

  bool isNan() => angle.isNaN || velocity.isNaN || position.isNaN;

  bool isInfinite() =>
      angle.isInfinite || velocity.isInfinite || position.isInfinite;
}
