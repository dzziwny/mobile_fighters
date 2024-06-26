import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../game_runner.dart';
import '../game.dart';

abstract class OnConnection implements Disposable {
  final game = GetIt.I<Game>();
  final runner = GetIt.I<GameRunner>();

  StreamSubscription? _mobileSubscription;

  static final _timers = List<Timer?>.filled(gameSettings.maxPlayers, null);

  late Player player;

  void onInit(int playerId, WebSocketChannel channel) {}

  void onData(int playerId, Uint8List data) {}

  Function handler() => (Request request, String id) async {
        final intId = int.tryParse(id);
        if (intId == null) {
          return Response(HttpStatus.badRequest);
        }

        player = game.players[intId];
        final handler = webSocketHandler(
          (WebSocketChannel channel) {
            onInit(intId, channel);
            _mobileSubscription = channel.stream.listen(
              (data) => onData(intId, data),
              onError: (error) {
                onChannelClose(intId);
              },
              onDone: () {
                onChannelClose(intId);
              },
            );
          },
        );

        final response = await handler(request);
        return response;
      };

  void onChannelClose(int id) {
    final timer = _timers[id];
    if (timer != null) {
      return;
    }

    _timers[id] = Timer(
      Duration(minutes: 1),
      () {
        game.removePlayer(id);
        final isAnyPlayer = game.players.any((player) => player.isActive);
        if (!isAnyPlayer) {
          runner.stopGame();
        }

        game.shareGameData();
        _timers[id] = null;
      },
    );
  }

  @override
  Future onDispose() async {
    await _mobileSubscription?.cancel();
  }
}
