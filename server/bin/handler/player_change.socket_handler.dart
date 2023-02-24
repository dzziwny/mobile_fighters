import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';
import 'on_connection.dart';

class PlayerChangeConnection extends OnConnection {
  @override
  void handler(
    WebSocketChannel channel,
    int playerId,
    List<int> Function(dynamic data) dataParser,
  ) {
    playerChangeWSChannels.add(channel);
  }
}
