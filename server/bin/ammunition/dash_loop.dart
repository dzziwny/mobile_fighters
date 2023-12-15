import 'dart:async';

import 'package:core/core.dart';
import 'package:vector_math/vector_math.dart';

import '../register_di.dart';
import '../setup.dart';
import 'loop.dart';

class DashLoop extends Cooldown {
  DashLoop({required super.cooldown});

  @override
  void onAction(int playerId) {
    players[playerId]
      ..isDashActive = true
      ..isDashActiveBit = Bits.dashActive
      ..isDashCooldownBit = Bits.dashCooldown;

    Timer(
      Duration(seconds: gameSettings.dashDuration),
      () {
        final state = playerInputs[playerId];
        final normalizedInput =
            Vector2(state.inputForceX, state.inputForceY).normalized();
        players[playerId]
          ..velocityX = normalizedInput.x * gameSettings.dashAfterForceRatio
          ..velocityY = normalizedInput.y * gameSettings.dashAfterForceRatio
          ..isDashActive = false
          ..isDashActiveBit = 0;
      },
    );
  }

  @override
  void onCooldownEnd(int playerId) {
    players[playerId].isDashCooldownBit = 0;
  }
}

var dashLoop = getDashLoop();
DashLoop getDashLoop() => DashLoop(
      cooldown: Duration(
        seconds: gameSettings.dashCooldown,
      ),
    );
