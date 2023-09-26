import 'dart:typed_data';

import 'package:core/core.dart';

import '../register_di.dart';
import 'on_connection.dart';

class MobileControlsConnection extends OnConnection {
  @override
  void onData(int playerId, Uint8List data) {
    final keysState = data[0];
    final x = data.toDouble(1, 5);
    final y = data.toDouble(5, 9);
    final angle = data.toDouble(9, 13);

    playerInputs[playerId]
      ..x = x
      ..y = y
      ..angle = angle
      ..isBullet = keysState.on(Bits.bullet);
  }
}
