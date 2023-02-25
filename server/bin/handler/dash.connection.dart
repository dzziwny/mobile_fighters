import 'dart:async';

import 'package:core/core.dart';
import 'package:web_socket_channel/src/channel.dart';

import '../setup.dart';
import 'on_connection.dart';

class DashConnection extends OnConnection {
  @override
  void onData(int playerId, List<int> data) {
    if (dashCooldowns[playerId] == true) {
      return;
    }

    final physic = playerPhysics[playerId];
    if (physic == null) {
      return;
    }

    final update = physic.velocity.normalized() * 50.0;
    physic.velocity.add(update);

    gameUpdates.add(() => _dashCooldownUpdate(playerId, true));
    dashCooldowns[playerId] = true;

    Timer(Duration(seconds: dashCooldownSesconds), () {
      gameUpdates.add(() => _dashCooldownUpdate(playerId, false));
      dashCooldowns[playerId] = false;
    });
  }

  @override
  void onInit(int playerId, WebSocketChannel channel) {
    dashChannels[playerId] = channel;
  }

  void _dashCooldownUpdate(int playerId, bool isCooldown) {
    final channel = cooldownWSChannels[playerId];
    if (channel == null) {
      return;
    }

    final frame = CooldownDto(
      isCooldown: isCooldown,
      cooldownType: CooldownType.dash,
    ).toData();

    channel.sink.add(frame);
  }
}
