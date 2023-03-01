import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

abstract class OnConnection implements Disposable {
  StreamSubscription? _mobileSubscription;

  void onInit(int playerId, WebSocketChannel channel) {}

  void onData(int playerId, Uint8List data) {}

  Function handler() => (Request request, String id) async {
        final intId = int.tryParse(id);
        if (intId == null) {
          return Response(HttpStatus.badRequest);
        }

        final handler = webSocketHandler(
          (WebSocketChannel channel) {
            onInit(intId, channel);
            _mobileSubscription = channel.stream.listen(
              (data) => onData(intId, data),
            );
          },
        );

        final response = await handler(request);
        return response;
      };

  @override
  Future onDispose() async {
    await _mobileSubscription?.cancel();
  }
}
