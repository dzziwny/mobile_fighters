import 'package:core/core.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../register_di.dart';
import 'on_connection.dart';

class GameDataConnection extends OnConnection {
  @override
  void onInit(int playerId, WebSocketChannel channel) {
    gameDataChannels.add(channel);
    final data = GameData(players: game.players).toString();
    channel.sink.add(data);
  }
}
