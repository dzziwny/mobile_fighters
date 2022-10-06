import 'dart:async';

import 'package:core/core.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';
import '../updates/_updates.dart';

void attackSocketHandler(WebSocketChannel channel) {
  attackWSChannels.add(channel);
  channel.stream.listen((data) => _attack(data));
}

void _attack(List<int> data) {
  final playerId = data[0];
  if (attackCooldowns[playerId] == true) {
    return;
  }

  gameUpdates.add(() => attackCooldownUpdate(playerId, true));
  gameUpdates.add(() => attackUpdate(data));
  attackCooldowns[playerId] = true;
  Timer(Duration(seconds: attackCooldownSesconds), () {
    gameUpdates.add(() => attackCooldownUpdate(playerId, false));
    attackCooldowns[playerId] = false;
  });
}

attackCooldownUpdate(int playerId, bool isCooldown) {
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
