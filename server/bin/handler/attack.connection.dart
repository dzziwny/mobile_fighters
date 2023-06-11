import 'dart:async';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../actions/action.dart';
import '../actions/create_bomb.action.dart';
import '../setup.dart';
import 'on_connection.dart';

class AttackConnection extends OnConnection {
  @override
  void onInit(int playerId, WebSocketChannel channel) {
    attackWSChannels.add(channel);
  }

  @override
  void onData(int playerId, Uint8List data) {
    if (attackCooldowns[playerId] == true) {
      return;
    }

    actions.add(CreateBombAction(playerId));
    actions.add(CreatingBombCooldownAction(playerId, true));
    attackCooldowns[playerId] = true;

    Timer(Duration(seconds: attackCooldownSesconds), () {
      actions.add(CreatingBombCooldownAction(playerId, false));
      attackCooldowns[playerId] = false;
    });
  }
}

Future<void> attackCooldownUpdate(int playerId, bool isCooldown) async {
  final channel = cooldownWSChannels[playerId];
  if (channel == null) {
    return;
  }

  final frame = CooldownDto(
    isCooldown: isCooldown,
    cooldownType: CooldownType.attack,
  ).toBytes();

  channel.sink.add(frame);
}
