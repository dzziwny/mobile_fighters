import 'package:core/core.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';
import 'on_connection.dart';

class CooldownConnection extends OnConnection {
  @override
  void onInit(int playerId, WebSocketChannel channel) {
    cooldownWSChannels[playerId] = channel;

    final attackCooldown = attackCooldowns[playerId];
    channel.sink.add(
      CooldownDto(
        isCooldown: attackCooldown == true,
        cooldownType: CooldownType.attack,
      ).toData(),
    );

    final dashCooldown = dashCooldowns[playerId];
    channel.sink.add(
      CooldownDto(
        isCooldown: dashCooldown == true,
        cooldownType: CooldownType.dash,
      ).toData(),
    );
  }

  @override
  void onData(int playerId, List<int> data) {}
}
