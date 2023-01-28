import 'dart:async';

import 'package:core/core.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';
import '../updates/_updates.dart';

void attackSocketConnection(WebSocketChannel channel, int playerId) {
  attackWSChannels.add(channel);
  channel.stream.listen((_) => _attack(playerId));
}

void _attack(int playerId) {
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
