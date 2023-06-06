import 'package:web_socket_channel/web_socket_channel.dart';

class ChannelsHandler {
  final List<WebSocketChannel> _pushChannels = [];
  final List<WebSocketChannel> _bulletChannels = [];
  final List<WebSocketChannel> _gameStateChannels = [];

  Future<void> addPushChannel(int playerId, WebSocketChannel channel) async =>
      _pushChannels.add(channel);
  Future<void> addBulletChannel(int playerId, WebSocketChannel channel) async =>
      _bulletChannels.add(channel);
  Future<void> addGameStateChannel(
          int playerId, WebSocketChannel channel) async =>
      _gameStateChannels.add(channel);

  Future<List<WebSocketChannel>> getPushChannel() async => _pushChannels;
  Future<List<WebSocketChannel>> getBulletChannels() async => _bulletChannels;
  Future<List<WebSocketChannel>> getGameStateChannels() async =>
      _gameStateChannels;
}
