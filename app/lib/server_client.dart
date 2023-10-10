import 'dart:async';

import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'di.dart';

class ServerClient implements Disposable {
  final _guid = uuid.v4();

  int id = 0;
  bool isInGame = false;

  late final StreamSubscription positionsSubscription;
  late final StreamSubscription myPositionSubscription;

  Future<void> connect(String ip) async {
    final response = await connect$(_guid, ip);
    id = response.id;
  }

  Future<void> createPlayer(String nick, Device device) async {
    await createPlayer$(_guid, id, nick, device);
    isInGame = true;
  }

  Future<void> backToTheGame() async {
    final player = gameService.gameData.players[id];
    await createPlayer(player.nick, player.device);
  }

  Future<void> leaveGame() async {
    await leaveGame$(_guid, id);
    isInGame = false;
  }

  @override
  Future onDispose() async {
    await Future.wait([
      positionsSubscription.cancel(),
      myPositionSubscription.cancel(),
    ]);
  }

  Stream<WebSocketChannel> channel(Socket socket) {
    final uri = Uri.parse('ws://$host:$port${socket.route(id: id)}');
    var channel = WebSocketChannel.connect(uri);
    return Stream.periodic(const Duration(seconds: 2)).map(
      (_) {
        if (channel.closeCode != null || channel.closeReason != null) {
          final uri = Uri.parse('ws://$host:$port${socket.route(id: id)}');
          channel = WebSocketChannel.connect(uri);
        }

        return channel;
      },
    ).distinct();
  }
}
