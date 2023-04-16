import 'package:web_socket_channel/web_socket_channel.dart';

class ChannelsHandler {
  final List<WebSocketChannel> _pushChannels = [];

  Future<void> addPushChannel(int playerId, WebSocketChannel channel) async {
    _pushChannels.add(channel);
  }

  Future<List<WebSocketChannel>> getPushChannel() async {
    return _pushChannels;
  }
}
