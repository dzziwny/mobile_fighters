import 'dart:typed_data';

import 'package:core/core.dart';

import '../handler/on_connection.dart';
import '../register_di.dart';
import '../setup.dart';

class MobileControlsConnection extends OnConnection {
  @override
  void onData(int playerId, Uint8List data) {
    final keysState = data[0];
    final x = data.toDouble(1, 5);
    if (x > 1.0 || x < -1.0) {
      return;
    }

    final y = data.toDouble(5, 9);
    if (y > 1.0 || y < -1.0) {
      return;
    }

    final angle = data.toDouble(9, 13);
    final player = players[playerId];
    playerInputs[playerId]
      ..inputForceX = x * player.forceRatio
      ..inputForceY = y * player.forceRatio
      ..angle = angle
      ..isBullet = keysState.on(Bits.bullet)
      ..isBomb = keysState.on(Bits.bomb)
      ..isDash = keysState.on(Bits.dash);
  }
}
