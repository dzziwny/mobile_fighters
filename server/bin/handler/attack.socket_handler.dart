import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';
import '../updates/_updates.dart';

void attackSocketHandler(WebSocketChannel channel) {
  attackWSChannels.add(channel);
  channel.stream.listen((data) => _attack(data));
}

void _attack(List<int> data) {
  gameUpdates.add(() => attackUpdate(data));
}
