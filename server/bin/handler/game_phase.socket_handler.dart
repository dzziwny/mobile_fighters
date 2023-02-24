import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';
import 'on_connection.dart';

class GamePhaseConnection extends OnConnection {
  @override
  void handler(
    WebSocketChannel channel,
    int playerId,
    List<int> Function(dynamic data) dataParser,
  ) {
    gamePhaseWSChannels[playerId] = channel;
    channel.sink.add([phase.index]);
  }
}
