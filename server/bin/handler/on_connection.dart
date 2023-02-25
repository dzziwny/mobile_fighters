import 'dart:async';
import 'dart:io';

import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class OnConnection implements Disposable {
  StreamSubscription? _mobileSubscription;
  StreamSubscription? _webSubscription;

  void onInit(int playerId, WebSocketChannel channel) {}

  void onData(int playerId, List<int> data) {}

  void _handleMobile(WebSocketChannel channel, int playerId) {
    _mobileSubscription = _handler(channel, playerId, (data) => data);
  }

  void _handleWeb(WebSocketChannel channel, int playerId) {
    _webSubscription = _handler(channel, playerId, (dynamic data) {
      if (data is! String) {
        throw Exception('unknown data');
      }

      if (data == '') {
        return [];
      }

      final intData = data.split(',').map((e) => int.parse(e)).toList();
      return intData;
    });
  }

  StreamSubscription _handler(
    WebSocketChannel channel,
    int playerId,
    List<int> Function(dynamic data) dataParser,
  ) {
    onInit(playerId, channel);
    return channel.stream.listen(
      (data) => onData(playerId, dataParser(data)),
    );
  }

  Function handler(bool isWeb) => (Request request, String id) async {
        final intId = int.tryParse(id);
        if (intId == null) {
          return Response(HttpStatus.badRequest);
        }

        final handler = webSocketHandler(
          (WebSocketChannel channel) => isWeb
              ? _handleWeb(channel, intId)
              : _handleMobile(channel, intId),
        );

        final response = await handler(request);
        return response;
      };

  @override
  Future onDispose() async {
    await _mobileSubscription?.cancel();
    await _webSubscription?.cancel();
  }
}
