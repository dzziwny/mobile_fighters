import 'package:get_it/get_it.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'channels.handler.dart';
import 'on_connection.dart';

class GameStateConnection extends OnConnection {
  final channelsHandler = GetIt.I<ChannelsHandler>();

  @override
  void onInit(int playerId, WebSocketChannel channel) {
    channelsHandler.addGameStateChannel(playerId, channel);
  }
}
