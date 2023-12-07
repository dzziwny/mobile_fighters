import 'package:core/src/game_settings.dart';
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
    position = gameSettings.resetPosition();
    velocity = Vector2.zero();
  }
}
