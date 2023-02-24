import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';
import 'on_connection.dart';

class PlayerChangeConnection extends OnConnection {
  @override
  void onInit(int playerId, WebSocketChannel channel) {
    playerChangeWSChannels.add(channel);
  }

  @override
  void onData(int playerId, List<int> data) {}
}
