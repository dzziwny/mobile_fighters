import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';

void playersSocketHandler(WebSocketChannel channel) {
  playersWSChannels.add(channel);
  final data = jsonEncode(players.values.toList());
  channel.sink.add(data);
}
