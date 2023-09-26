import 'package:web_socket_channel/web_socket_channel.dart';

import '../register_di.dart';
import 'on_connection.dart';

class GameStateConnection extends OnConnection {
  @override
  void onInit(int playerId, WebSocketChannel channel) {
    gameStateChannels.add(channel);
  }
}
