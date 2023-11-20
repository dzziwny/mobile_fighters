import 'dart:typed_data';

import 'package:core/core.dart';

import '../handler/on_connection.dart';
import '../register_di.dart';

class DesktopControlsConnection extends OnConnection {
  @override
  void onData(int playerId, Uint8List data) {
    final state = data[0];
    double x = 0.0;
    final xState = state & Bits.x;
    if (xState == Bits.a) {
      x = -player.forceRatio;
    } else if (xState == Bits.d) {
      x = player.forceRatio;
    }

    double y = 0.0;
    final yState = state & Bits.y;
    if (yState == Bits.w) {
      y = -player.forceRatio;
    } else if (yState == Bits.s) {
      y = player.forceRatio;
    }

    final angle = data.toDouble(1, 5);
    playerInputs[playerId]
      ..inputForceX = x
      ..inputForceY = y
      ..angle = angle
      ..isBullet = state.on(Bits.bullet)
      ..isBomb = state.on(Bits.bomb)
      ..isDash = state.on(Bits.dash);
  }
}
