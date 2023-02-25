import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';
import 'on_connection.dart';

class HitConnection extends OnConnection {
  @override
  void onInit(int playerId, WebSocketChannel channel) {
    hitWSChannels.add(channel);
  }
}
