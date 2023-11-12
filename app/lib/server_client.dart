import 'dart:async';

import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'game_state/game_state.service.dart';

class ServerClient implements Disposable {
  final _guid = const Uuid().v4();

  int id = 0;
  String ip = '';
  bool isInGame = false;
  final connected = Completer();

  late final StreamSubscription positionsSubscription;
  late final StreamSubscription myPositionSubscription;

  Future<void> connect(String ip) async {
    this.ip = ip;
    final response = await connect$(_guid, 'http://$ip');
    id = response.id;
    connected.complete();
  }

  Future<void> createPlayer(String nick, Device device) async {
    await createPlayer$(_guid, 'http://$ip', id, nick, device);
    isInGame = true;
  }

  Future<void> backToTheGame() async {
    final player = gameService.gameData.players[id];
    await createPlayer(player.nick, player.device);
  }

  Future<void> leaveGame() async {
    await leaveGame$(_guid, id, 'http://$ip');
    isInGame = false;
  }

  Future<void> setGamePhysics(GamePhysics physics) =>
      setGamePhysics$(physics, 'http://$ip');

  Stream<WebSocketChannel> channel(Socket socket) async* {
    await connected.future;
    final uri = Uri.parse('ws://$ip${socket.route(id: id)}');
    var channel = WebSocketChannel.connect(uri);
    yield* Stream.periodic(const Duration(seconds: 2)).map(
      (_) {
        if (channel.closeCode != null || channel.closeReason != null) {
          final uri = Uri.parse('ws://$ip${socket.route(id: id)}');
          channel = WebSocketChannel.connect(uri);
        }

        return channel;
      },
    ).distinct();
  }

  @override
  Future onDispose() async {
    await Future.wait([
      positionsSubscription.cancel(),
      myPositionSubscription.cancel(),
    ]);
  }
}

final serverClient = ServerClient();
