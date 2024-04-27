import 'dart:math';

import 'package:core/core.dart';
import 'package:vector_math/vector_math.dart';

import '../game_setup.dart';
import 'loop.dart';

abstract class AmmunitionCooldown<T extends Ammunition> extends Cooldown {
  final int ammunitionPerPlayer;
  final List<T> magazine;
  final List<int> currentAmmo;
  final double initVelocity;

  AmmunitionCooldown({
    required this.ammunitionPerPlayer,
    required this.magazine,
    required this.currentAmmo,
    required this.initVelocity,
    required super.cooldown,
  });

  @override
  void onAction(int playerId) {
    final firstAmmo = playerId * ammunitionPerPlayer;
    final reset = (playerId + 1) * ammunitionPerPlayer;
    var currentAttack = currentAmmo[playerId];
    if (currentAttack == reset) {
      currentAttack = firstAmmo;
    }

    final player = players[playerId];
    final velocity = _initVelocityVector(player.angle, initVelocity);
    final position = Vector2(player.x, player.y);

    magazine[playerId]
      ..shooterId = playerId
      ..velocity = velocity
      ..angle = player.angle
      ..startPosition = position
      ..position = position;
    currentAmmo[playerId] = ++currentAttack;
  }

  Vector2 _initVelocityVector(double angle, double velocity) {
    return Vector2(sin(angle), -cos(angle)).normalized()..scale(velocity);
  }
}
