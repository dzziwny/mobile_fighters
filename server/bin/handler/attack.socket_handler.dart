import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';

void attackSocketHandler(WebSocketChannel channel) {
  attackWSChannels.add(channel);
  channel.stream.listen((data) => _attack(data));
}

void _attack(List<int> data) {
  gameUpdates.add([1, ...data]);
}
