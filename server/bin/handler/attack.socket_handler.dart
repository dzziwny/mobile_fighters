import 'dart:async';

import 'package:core/core.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';
import '../updates/_updates.dart';
import 'on_connection.dart';

class AttackConnection extends OnConnection {
  @override
  void handler(
    WebSocketChannel channel,
    int playerId,
    List<int> Function(dynamic data) dataParser,
  ) {
    attackWSChannels.add(channel);
    channel.stream.listen((data) => _attack(dataParser(data), playerId));
  }

  void _attack(List<int> data, int playerId) {
    if (attackCooldowns[playerId] == true) {
      return;
    }

    gameUpdates.add(() => attackUpdate(playerId));
    gameUpdates.add(() => _attackCooldownUpdate(playerId, true));
    attackCooldowns[playerId] = true;

    Timer(Duration(seconds: attackCooldownSesconds), () {
      gameUpdates.add(() => _attackCooldownUpdate(playerId, false));
      attackCooldowns[playerId] = false;
    });
  }

  void _attackCooldownUpdate(int playerId, bool isCooldown) {
    final channel = cooldownWSChannels[playerId];
    if (channel == null) {
      return;
    }

    final frame = CooldownDto(
      isCooldown: isCooldown,
      cooldownType: CooldownType.attack,
    ).toData();

    channel.sink.add(frame);
  }
}
