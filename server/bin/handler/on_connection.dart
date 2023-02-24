import 'package:web_socket_channel/web_socket_channel.dart';

abstract class OnConnection {
  void handleMobile(
    WebSocketChannel channel,
    int playerId,
  ) {
    handler(channel, playerId, (dynamic data) => data);
  }

  void handleWeb(WebSocketChannel channel, int playerId) {
    handler(channel, playerId, (dynamic data) {
      if (data is! String) {
        throw Exception('unknown data');
      }

      final intData = data.split(',').map((e) => int.parse(e)).toList();
      return intData;
    });
  }

  void handler(
    WebSocketChannel channel,
    int playerId,
    List<int> Function(dynamic data) dataParser,
  );
}
