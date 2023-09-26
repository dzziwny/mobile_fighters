import 'dart:typed_data';

import 'package:core/core.dart';

import '../register_di.dart';
import 'on_connection.dart';

class ActionsConnection extends OnConnection {
  @override
  void onData(int playerId, Uint8List data) {
    final state = data[0];
    if (!actionsStates[playerId].isBombCooldown && state.on(Bits.bomb)) {
      actionsStates[playerId].bomb = true;
    }

    if (!actionsStates[playerId].isDashCooldown && state.on(Bits.dash)) {
      actionsStates[playerId].dash = true;
    }
  }
}
