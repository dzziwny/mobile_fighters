import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';

void hitSocketHandler(WebSocketChannel channel) {
  hitWSChannels.add(channel);
}
