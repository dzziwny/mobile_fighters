import 'dart:typed_data';

import 'package:core/core.dart';

import '../register_di.dart';
import 'on_connection.dart';

class DesktopControlsConnection extends OnConnection {
  @override
  void onData(int playerId, Uint8List data) {
    final state = data[0];
    double x = 0.0;
    final xState = state & Bits.x;
    if (xState == Bits.a) {
      x = -gamePhysics.f;
    } else if (xState == Bits.d) {
      x = gamePhysics.f;
    }

    double y = 0.0;
    final yState = state & Bits.y;
    if (yState == Bits.w) {
      y = -gamePhysics.f;
    } else if (yState == Bits.s) {
      y = gamePhysics.f;
    }

    final angle = data.toDouble(1, 5);
    playerInputs[playerId]
      ..x = x
      ..y = y
      ..angle = angle
      ..isBullet = state.on(Bits.bullet)
      ..isBomb = state.on(Bits.bomb);
  }
}
