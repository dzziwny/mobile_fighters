import 'package:shelf/shelf.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';

gamePhaseSocketHandler(Request request, String id) =>
    webSocketHandler(_handler(id))(request);

_handler(String playerId) => (WebSocketChannel channel) {
      final id = int.tryParse(playerId);
      if (id == null) {
        return;
      }

      final player = players[playerId];
      if (player == null) {
        return;
      }

      gamePhaseWSChannels[id] = channel;
      channel.sink.add([phase.index]);
    };
