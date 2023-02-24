import 'package:core/core.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';
import 'on_connection.dart';

class CooldownConnection extends OnConnection {
  @override
  void handler(
    WebSocketChannel channel,
    int playerId,
    List<int> Function(dynamic data) dataParser,
  ) {
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
}
