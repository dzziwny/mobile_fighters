import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';
import 'on_connection.dart';

class GamePhaseConnection extends OnConnection {
  @override
  void onInit(int playerId, WebSocketChannel channel) {
    gamePhaseWSChannels[playerId] = channel;
    channel.sink.add([phase.index]);
  }
}
