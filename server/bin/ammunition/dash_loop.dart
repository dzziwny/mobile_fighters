import 'dart:async';

import 'package:core/core.dart';

import '../setup.dart';
import 'loop.dart';

class DashLoop extends Cooldown {
  DashLoop({required super.cooldown});

  @override
  void action(int playerId) {
    final player = players[playerId];
    player.frictionK = dashFrictionK;
    player.forceRatio = dashforceRation;
    player.isDashActiveBit = Bits.dashActive;
    Timer(
      dashDuration,
      () {
        player.frictionK = defaultPlayerFrictionK;
        player.forceRatio = defaultPlayerForceRatio;
        player.isDashActiveBit = 0;
      },
    );
  }
}

final dashLoop = DashLoop(cooldown: dashCooldown);
