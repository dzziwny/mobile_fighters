import 'dart:async';

import 'package:core/core.dart';

abstract class Cooldown {
  final List<bool> states = List.filled(maxPlayers, false);
  final Duration cooldown;

  final timers = List.generate(
    maxPlayers,
    (_) => Timer(Duration.zero, () {})..cancel(),
  );

  Cooldown({required this.cooldown});

  void toggle(int playerId, bool state) {
    states[playerId] = state;
    if (timers[playerId].isActive || !state) {
      return;
    }

    _startLoop(playerId);
  }

  void _startLoop(int playerId) {
    onAction(playerId);
    timers[playerId] = Timer.periodic(
      cooldown,
      (timer) {
        if (states[playerId]) {
          onAction(playerId);
        } else {
          timers[playerId].cancel();
          onCooldownEnd(playerId);
        }
      },
    );
  }

  void onAction(int playerId);
  void onCooldownEnd(int playerId);
}
