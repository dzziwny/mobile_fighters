import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';

void playerChangeSocketHandler(WebSocketChannel channel) {
  playerChangeWSChannels.add(channel);
}
