import 'dart:async';
import 'dart:math';

import 'package:core/core.dart';
import 'package:vector_math/vector_math.dart';

import 'setup.dart';

abstract class AmmunitionLoop<T extends Ammunition> {
  final int ammunitionPerPlayer;
  final List<T> magazine;
  final List<int> currentAmmo;
  final List<bool> states = List.filled(maxPlayers, false);
  final Duration cooldown;
  final double initVelocity;

  final timers = List.generate(
    maxPlayers,
    (_) => Timer(Duration.zero, () {})..cancel(),
  );

  AmmunitionLoop({
    required this.ammunitionPerPlayer,
    required this.magazine,
    required this.currentAmmo,
    required this.cooldown,
    required this.initVelocity,
  });

  void toggle(int playerId, bool state) {
    states[playerId] = state;
    if (timers[playerId].isActive || !state) {
      return;
    }

    _startLoop(playerId);
  }

  void _startLoop(int playerId) {
    final firstAmmo = playerId * ammunitionPerPlayer;
    final reset = (playerId + 1) * ammunitionPerPlayer;
    final timer = timers[playerId];
    executeStep(playerId, timer, firstAmmo, reset);
    timers[playerId] = Timer.periodic(
      cooldown,
      (timer) {
        if (states[playerId]) {
          executeStep(playerId, timer, firstAmmo, reset);
        } else {
          timers[playerId].cancel();
        }
      },
    );
  }

  void executeStep(
    int playerId,
    Timer timer,
    int firstAmmo,
    int reset,
  ) {
    var currentAttack = currentAmmo[playerId];
    if (currentAttack == reset) {
      currentAttack = firstAmmo;
    }

    create(currentAttack, playerId);
    currentAmmo[playerId] = ++currentAttack;
  }

  void create(int id, int playerId) {
    final player = players[playerId];
    final velocity = Vector2(sin(player.angle), -cos(player.angle)).normalized()
      ..scale(initVelocity);

    final position = Vector2(player.x, player.y);
    magazine[id]
      ..shooterId = playerId
      ..velocity = velocity
      ..angle = player.angle
      ..startPosition = position
      ..position = position;
  }
}
