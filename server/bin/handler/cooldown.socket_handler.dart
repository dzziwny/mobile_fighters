import 'package:core/core.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';

cooldownSocketHandler(String playerId) => (WebSocketChannel channel) {
      final id = int.parse(playerId);
      final attackCooldown = attackCooldowns[id];
      channel.sink.add(
        CooldownDto(
          isCooldown: attackCooldown == true,
          cooldownType: CooldownType.attack,
        ).toData(),
      );

      final dashCooldown = dashCooldowns[id];
      channel.sink.add(
        CooldownDto(
          isCooldown: dashCooldown == true,
          cooldownType: CooldownType.dash,
        ).toData(),
      );

      cooldownWSChannels[id] = channel;
    };
