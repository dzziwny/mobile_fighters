import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';
import 'on_connection.dart';

class DeadConnection extends OnConnection {
  @override
  void onInit(int playerId, WebSocketChannel channel) {
    fragWSChannels[playerId] = channel;
  }
}
