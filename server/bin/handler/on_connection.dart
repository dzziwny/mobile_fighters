import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';

abstract class OnConnection implements Disposable {
  StreamSubscription? _mobileSubscription;

  late final Player player;

  void onInit(int playerId, WebSocketChannel channel) {}

  void onData(int playerId, Uint8List data) {}

  Function handler() => (Request request, String id) async {
        final intId = int.tryParse(id);
        if (intId == null) {
          return Response(HttpStatus.badRequest);
        }

        player = players[intId];
        final handler = webSocketHandler(
          (WebSocketChannel channel) {
            onInit(intId, channel);
            _mobileSubscription = channel.stream.listen(
              (data) => onData(intId, data),
              onError: (error) {
                print('Error: $error');
              },
              onDone: () {
                // TODO dac userowi np. minute i kick
                print('Done');
              },
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
