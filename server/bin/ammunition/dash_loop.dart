import 'dart:async';

import 'package:core/core.dart';

import '../setup.dart';
import 'loop.dart';

class DashLoop extends Cooldown {
  DashLoop({required super.cooldown});

  @override
  void onAction(int playerId) {
    players[playerId]
      ..frictionK = dashFrictionK
      ..forceRatio = dashforceRation
      ..isDashActiveBit = Bits.dashActive
      ..isDashCooldownBit = Bits.dashCooldown;

    Timer(
      dashDuration,
      () {
        players[playerId]
          ..frictionK = defaultPlayerFrictionK
          ..forceRatio = defaultPlayerForceRatio
          ..isDashActiveBit = 0;
      },
    );
  }

  @override
  void onCooldownEnd(int playerId) {
    players[playerId].isDashCooldownBit = 0;
  }
}

final dashLoop = DashLoop(cooldown: dashCooldown);
