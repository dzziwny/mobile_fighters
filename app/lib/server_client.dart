import 'dart:async';

import 'package:bubble_fight/rxdart.extension.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class ServerClient implements Disposable {
  final _guid = const Uuid().v4().hashCode;

  final id$ = BehaviorSubject<int?>.seeded(null);

  final myPlayer$ = ReplaySubject<Player>(maxSize: 1);

  late final StreamSubscription positionsSubscription;
  late final StreamSubscription myPositionSubscription;

  /*
  * Streams
  */
  Future<int> createPlayer(String nick, Device device) async {
    final dto = await createPlayer$(_guid, nick, device);
    myPlayer$.add(
      Player(id: dto.id, device: device, nick: nick, team: dto.team),
    );

    final id = dto.id;

    id$.add(id);
    return id;
  }

  Future<int> backToTheGame() async {
    final player = await myPlayer$.first;
    return await createPlayer(player.nick, player.device);
  }

  Future<void> leaveGame() => leaveGame$(_guid).then((_) => id$.add(null));

  Stream<bool> isInGame() => id$.map((id) => id != null);

  final Future<GameFrame> gameFrame = gameFrame$();

  /*
  * Converters
  */

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
