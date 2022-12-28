import 'dart:async';
import 'dart:convert';

import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

class ServerClient implements Disposable {
  final _guid = const Uuid().v4().hashCode;
  final _positions = <int, Position>{};

  final rawDataChannel = WebSocketChannel.connect(
    Uri.parse(
        'ws://$host:$port${kIsWeb ? Endpoint.rawDataWsWeb : Endpoint.rawDataWs}'),
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

  late final cooldownChannel = id$
      .where((id) => id != null)
      .map(
        (id) => WebSocketChannel.connect(
          Uri.parse('ws://$host:$port${Endpoint.cooldownWs(id!)}'),
        ),
      )
      .shareReplay(maxSize: 1);

  late final deadChannel = id$
      .where((id) => id != null)
      .map(
        (id) => WebSocketChannel.connect(
          Uri.parse('ws://$host:$port${Endpoint.deadWs(id!)}'),
        ),
      )
      .shareReplay(maxSize: 1);

  // TODO add .shareReplay(maxSize: 1); to others
  late final selectTeamChannel = id$
      .where((id) => id != null)
      .map(
        (id) => WebSocketChannel.connect(
          Uri.parse('ws://$host:$port${Endpoint.selectTeamWs(id!)}'),
        ),
      )
      .shareReplay(maxSize: 1);

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
  late final Stream<dynamic> deadData$ =
      deadChannel.switchMap((channel) => channel.stream).asBroadcastStream();
  late final Stream<dynamic> teamsData$ = selectTeamChannel
      .switchMap((channel) => channel.stream)
      .asBroadcastStream();

  final id$ = BehaviorSubject<int?>.seeded(null);

  final myPlayer$ = ReplaySubject<Player>(maxSize: 1);

  late final StreamSubscription positionsSubscription;
  late final StreamSubscription myPositionSubscription;
  late final StreamSubscription playersSubscription;

  ServerClient() {
    positionsSubscription = positions$.connect();
    myPositionSubscription = myPosition$.connect();
    playersSubscription = players$.connect();
  }

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

  void updatePosition(
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

  late final myPosition$ = id$
      .switchMap(
          (id) => position$().where((position) => position.playerId == id))
      .publishReplay(maxSize: 1);

  Stream<Position> position$() =>
      positionsData$.asBroadcastStream().map((data) => _dataToPosition(data));

  late final positions$ = position$().map((position) {
    _positions[position.playerId] = position;
    return _positions;
  }).publishReplay(maxSize: 1);

  Stream<PlayerChangeDto> playerChange$() => playersChangeData$
      .asBroadcastStream()
      .map((data) => _dataToPlayerChange(data));

  late final players$ = playersData$
      .asBroadcastStream()
      .map((data) => _dataToPlayers(data))
      .publishReplay(maxSize: 1);

  Stream<Position> attack$() =>
      attackData$.asBroadcastStream().map((data) => _dataToAttack(data));

  Stream<HitDto> hit$() =>
      hitData$.asBroadcastStream().map((data) => _dataToHit(data));

  late Stream<CooldownDto> cooldown$ =
      cooldownData$.asBroadcastStream().map((data) => _dataToCooldown(data));

  late Stream<int> dead$ =
      deadData$.asBroadcastStream().map((data) => _dataToDead(data));

  late Stream<TeamsDto> teams$ = teamsData$.asBroadcastStream().map((data) {
    return _dataToTeams(data);
  });

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

  int _dataToDead(List<int> data) {
    leaveGame();
    final attackingPlayerId = data[0];
    return attackingPlayerId;
  }

  TeamsDto _dataToTeams(data) {
    final teams = TeamsDto.fromJson(jsonDecode(data));
    return teams;
  }

  @override
  Future onDispose() async {
    await Future.wait([
      rawDataChannel.sink.close(status.goingAway),
      playersChannel.sink.close(status.goingAway),
      addOrRemovePlayerChannel.sink.close(status.goingAway),
      attackChannel.sink.close(status.goingAway),
      hitChannel.sink.close(status.goingAway),
      positionsSubscription.cancel(),
      myPositionSubscription.cancel(),
      playersSubscription.cancel(),
    ]);
  }

  Stream<bool> isSelectingTeam$() {
    return Stream.value(true);
  }

  Stream<List<String>> fluentTeam$() {
    return teams$.map((teams) => teams.fluent);
  }

  Stream<List<String>> cupertinoTeam$() {
    return teams$.map((teams) => teams.cupertino);
  }

  Stream<List<String>> materialTeam$() {
    return teams$.map((teams) => teams.material);
  }

  Stream<List<String>> spectatorsTeam$() {
    return teams$.map((teams) => teams.spectators);
  }

  Future<void> selectBlueTeam() async {
    final channel = await selectTeamChannel.first;
    final data = [0, 0];
    channel.sink.add(data);
  }

  Future<void> selectRedTeam() async {
    final channel = await selectTeamChannel.first;
    final data = [0, 1];
    channel.sink.add(data);
  }
}
