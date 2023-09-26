import 'package:core/core.dart';

import 'setup.dart';

void bombPhysicUpdate(Bomb bomb, double dt) {
  // final player = players[bomb.id];
  // final velocity = Vector2(sin(player.angle), -cos(player.angle)).normalized()
  //   ..scale(100);

  final position = bomb.position + bomb.velocity * dt;

  if (position.x < 0.0 ||
      position.x > boardWidth ||
      position.y < 0.0 ||
      position.y > boardHeight) {
    bombs[bomb.id].isActive = false;
    return;
  }
}
