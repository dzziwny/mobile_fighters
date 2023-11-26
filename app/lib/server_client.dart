import 'dart:async';

import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'uuid.dart';

class ServerClient implements Disposable {
  final String uuid;

  ServerClient({required this.uuid});

  final _id$ = ReplaySubject<int>(maxSize: 1);
  var id = 0;
  String ip = '';

  late final StreamSubscription positionsSubscription;
  late final StreamSubscription myPositionSubscription;

  Future<void> connect(String ip, String nick, Device device) async {
    this.ip = ip;
    final response = await connect$(uuid, 'http://$ip', nick, device);
    _id$.add(response.id);
    id = response.id;
  }

  Future<void> leaveGame() async {
    final id = await _id$.first;
    await leaveGame$(uuid, id, 'http://$ip');
  }

  Future<void> setGamePhysics(GamePhysics physics) =>
      setGamePhysics$(physics, 'http://$ip');

  Stream<WebSocketChannel> channel(Socket socket) {
    return _id$.switchMap((id) {
      final uri = Uri.parse('ws://$ip${socket.route(id: id)}');
      var channel = WebSocketChannel.connect(uri);
      return Stream.periodic(const Duration(seconds: 2)).map(
        (_) {
          if (channel.closeCode != null || channel.closeReason != null) {
            final uri = Uri.parse('ws://$ip${socket.route(id: id)}');
            channel = WebSocketChannel.connect(uri);
          }

          return channel;
        },
      ).distinct();
    });
  }

  @override
  Future onDispose() async {
    await Future.wait([
      positionsSubscription.cancel(),
      myPositionSubscription.cancel(),
    ]);
  }
}

final serverClient = ServerClient(uuid: uuid);
