import 'dart:async';

import 'package:core/core.dart';

import '../setup.dart';
import 'loop.dart';

class DashLoop extends Cooldown {
  DashLoop({required super.cooldown});

  @override
  void onAction(int playerId) {
    players[playerId]
      ..frictionK = gameSettings.frictionK
      ..forceRatio = gameSettings.forceRatio
      ..isDashActiveBit = Bits.dashActive
      ..isDashCooldownBit = Bits.dashCooldown;

    Timer(
      Duration(seconds: gameSettings.dashDuration),
      () {
        players[playerId]
          ..frictionK = gameSettings.frictionK
          ..forceRatio = gameSettings.forceRatio
          ..isDashActiveBit = 0;
      },
    );
  }

  @override
  void onCooldownEnd(int playerId) {
    players[playerId].isDashCooldownBit = 0;
  }
}

final dashLoop = DashLoop(
  cooldown: Duration(
    seconds: gameSettings.dashCooldown,
  ),
);
