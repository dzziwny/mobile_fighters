import 'dart:async';

import 'package:bubble_fight/rxdart.extension.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'di.dart';

class ServerClient implements Disposable {
  final _guid = uuid.v4();

  final id$ = ReplaySubject<int>(maxSize: 1);

  final myPlayer$ = BehaviorSubject<Player?>.seeded(null);

  late final StreamSubscription positionsSubscription;
  late final StreamSubscription myPositionSubscription;

  Future<void> connect() async {
    final response = await connect$(_guid);
    id$.add(response.id);
  }

  Future<void> createPlayer(String nick, Device device) async {
    final id = await id$.first;
    final dto = await createPlayer$(_guid, id, nick, device);
    myPlayer$.add(
      Player(id: dto.id, device: device, nick: nick, team: dto.team),
    );
  }

  Future<void> backToTheGame() async {
    final player = await myPlayer$.first;
    if (player == null) {
      throw Exception('Cannot back to the game without a player.. i think xd');
    }

    await createPlayer(player.nick, player.device);
  }

  Future<void> leaveGame() async {
    final id = await id$.first;
    await leaveGame$(_guid, id).then((_) => myPlayer$.add(null));
  }

  Stream<bool> isInGame() => myPlayer$.map((player) => player != null);

  final Future<GameFrame> gameFrame = gameFrame$();

  // TODO add leaving game after dead
  // int _dataToDead(List<int> data) {
  //   leaveGame();
  //   final attackingPlayerId = data[0];
  //   return attackingPlayerId;
  // }

  @override
  Future onDispose() async {
    await Future.wait([
      positionsSubscription.cancel(),
      myPositionSubscription.cancel(),
    ]);
  }

  Stream<WebSocketChannel> channel(String Function(int) uriBuilder) {
    return id$.skipNull().map((id) {
      final uri = Uri.parse('ws://$host:$port${uriBuilder(id)}');
      final channel = WebSocketChannel.connect(uri);
      return channel;
    });
  }
}
