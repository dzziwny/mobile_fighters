import 'dart:convert';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';
import 'on_connection.dart';

class PlayersConnection extends OnConnection {
  @override
  void onInit(int playerId, WebSocketChannel channel) {
    playersWSChannels.add(channel);
    final data = jsonEncode(players.values.toList());
    channel.sink.add(data);
  }
}
