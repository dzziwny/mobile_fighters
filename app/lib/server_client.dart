import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

class ServerClient implements Disposable {
  final _guid = const Uuid().v4().hashCode;

  final rawDataChannel = WebSocketChannel.connect(
    Uri.parse('ws://$host:$port${Endpoint.rawDataWs}'),
  );
  final playersChannel = WebSocketChannel.connect(
    Uri.parse('ws://$host:$port${Endpoint.playersWs}'),
  );
  final addOrRemovePlayerChannel = WebSocketChannel.connect(
    Uri.parse('ws://$host:$port${Endpoint.playerChangeWs}'),
  );
  final attackChannel = WebSocketChannel.connect(
    Uri.parse('ws://$host:$port${Endpoint.attackWs}'),
  );
  final hitChannel = WebSocketChannel.connect(
    Uri.parse('ws://$host:$port${Endpoint.hitWs}'),
  );

  late final cooldownChannel = id$.where((id) => id != null).map(
        (id) => WebSocketChannel.connect(
          Uri.parse('ws://$host:$port${Endpoint.cooldownWs(id!)}'),
        ),
      );

  late final Stream<dynamic> positionsData$ =
      rawDataChannel.stream.asBroadcastStream();
  late final Stream<dynamic> playersData$ =
      playersChannel.stream.asBroadcastStream();
  late final Stream<dynamic> playersChangeData$ =
      addOrRemovePlayerChannel.stream.asBroadcastStream();
  late final Stream<dynamic> attackData$ =
      attackChannel.stream.asBroadcastStream();
  late final Stream<dynamic> hitData$ = hitChannel.stream.asBroadcastStream();
  late final Stream<dynamic> cooldownData$ = cooldownChannel
      .switchMap((channel) => channel.stream)
      .asBroadcastStream();

  final id$ = BehaviorSubject<int?>.seeded(null);

  void dash() {
    final data = <int>[
      1,
      // TODO: user can't just update position for someone else
      id$.value!,
    ];

    rawDataChannel.sink.add(data);
  }

  void attack() {
    final data = <int>[
      id$.value!,
    ];

    attackChannel.sink.add(data);
  }

  void updateKnob(
    double angle,
    double deltaX,
    double deltaY,
  ) {
    final angleBytes = (ByteData(4)..setFloat32(0, angle)).buffer.asUint8List();
    final deltaXBytes =
        (ByteData(4)..setFloat32(0, deltaX)).buffer.asUint8List();
    final deltaYBytes =
        (ByteData(4)..setFloat32(0, deltaY)).buffer.asUint8List();

    final frame = <int>[
      0,
      // TODO: user can't just update position for someone else
      id$.value!,
      ...angleBytes,
      ...deltaXBytes,
      ...deltaYBytes,
    ];

    rawDataChannel.sink.add(frame);
  }

  /*
  * Streams
  */
  Future<int> createPlayer(String nick) async {
    final dto = await createPlayer$(_guid, nick);

    final id = dto.id;

    id$.add(id);
    return id;
  }

  Future<void> leaveGame() => leaveGame$(_guid).then((_) => id$.add(null));

  Stream<bool> isInGame() => id$.map((id) => id != null);

  Future<GameFrame> gameFrame() => gameFrame$();

  Stream<Position> position$() =>
      positionsData$.asBroadcastStream().map((data) => _dataToPosition(data));

  Stream<PlayerChangeDto> playerChange$() => playersChangeData$
      .asBroadcastStream()
      .map((data) => _dataToPlayerChange(data));

  Stream<List<Player>> players$() =>
      playersData$.asBroadcastStream().map((data) => _dataToPlayers(data));

  Stream<Position> attack$() =>
      attackData$.asBroadcastStream().map((data) => _dataToAttack(data));

  Stream<HitDto> hit$() =>
      hitData$.asBroadcastStream().map((data) => _dataToHit(data));

  late Stream<CooldownDto> cooldown$ =
      cooldownData$.asBroadcastStream().map((data) => _dataToCooldown(data));

  /*
  * Converters
  */
  List<Player> _dataToPlayers(String data) {
    final json = jsonDecode(data);
    final List list = json;
    final players = list.map((e) => Player.fromJson(e)).toList();
    return players;
  }

  Position _dataToPosition(List<int> data) {
    final playerId = data[0];
    final position = Position(
      playerId,
      ByteData.sublistView(Uint8List.fromList(data.sublist(1, 5)))
          .getFloat32(0),
      ByteData.sublistView(Uint8List.fromList(data.sublist(5, 9)))
          .getFloat32(0),
      ByteData.sublistView(Uint8List.fromList(data.sublist(9, 13)))
          .getFloat32(0),
    );

    return position;
  }

  PlayerChangeDto _dataToPlayerChange(String data) {
    final json = jsonDecode(data);
    final dto = PlayerChangeDto.fromJson(json);
    return dto;
  }

  Position _dataToAttack(List<int> data) {
    final position = _dataToPosition(data);
    return position;
  }

  HitDto _dataToHit(List<int> data) {
    final dto = HitDto(playerId: data[0], hp: data[1]);
    return dto;
  }

  CooldownDto _dataToCooldown(List<int> data) {
    final dto = CooldownDto.fromData(data);
    return dto;
  }

  @override
  FutureOr onDispose() {
    rawDataChannel.sink.close(status.goingAway);
    playersChannel.sink.close(status.goingAway);
    addOrRemovePlayerChannel.sink.close(status.goingAway);
  }
}
