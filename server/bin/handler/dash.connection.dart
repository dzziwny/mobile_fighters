import 'dart:async';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:web_socket_channel/src/channel.dart';

import '../actions/action.dart';
import '../setup.dart';
import 'on_connection.dart';

class DashConnection extends OnConnection {
  @override
  void onData(int playerId, Uint8List data) {
    if (dashCooldowns[playerId] == true) {
      return;
    }

    final physic = playerPhysics[playerId];
    if (physic == null) {
      return;
    }

    final update = physic.velocity.normalized() * 50.0;
    physic.velocity.add(update);

    actions.add(DashCooldownAction(playerId, true));
    dashCooldowns[playerId] = true;

    Timer(Duration(seconds: dashCooldownSesconds), () {
      actions.add(DashCooldownAction(playerId, false));
      dashCooldowns[playerId] = false;
    });
  }

  @override
  void onInit(int playerId, WebSocketChannel channel) {
    dashChannels[playerId] = channel;
  }
}

Future<void> dashCooldownUpdate(int playerId, bool isCooldown) async {
  final channel = cooldownWSChannels[playerId];
  if (channel == null) {
    return;
  }

  final frame = CooldownDto(
    isCooldown: isCooldown,
    cooldownType: CooldownType.dash,
  ).toBytes();

  channel.sink.add(frame);
}
