import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';

deadSocketHandler(String playerId) => (WebSocketChannel channel) {
      final id = int.parse(playerId);
      deadWSChannels[id] = channel;
    };
