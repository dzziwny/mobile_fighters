import 'dart:async';
import 'dart:convert';

import 'package:bubble_fight/rxdart.extension.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

import 'endpoints.dart';

class ServerClient implements Disposable {
  final _guid = const Uuid().v4().hashCode;

  final addOrRemovePlayerChannel = WebSocketChannel.connect(
    Uri.parse('ws://$host:$port${Endpoint.playerChangeWs}'),
  );
  final hitChannel = WebSocketChannel.connect(
    Uri.parse('ws://$host:$port${Endpoint.hitWs}'),
  );

  late final selectTeamChannel = id$
      .where((id) => id != null)
      .map(
        (id) => WebSocketChannel.connect(
          Uri.parse('ws://$host:$port${Route.selectTeamWs(id!)}'),
        ),
      )
      .shareReplay(maxSize: 1);

  late final Stream<dynamic> playersChangeData$ =
      addOrRemovePlayerChannel.stream.asBroadcastStream();
  late final Stream<dynamic> hitData$ = hitChannel.stream.asBroadcastStream();
  late final Stream<dynamic> teamsData$ = selectTeamChannel
      .switchMap((channel) => channel.stream)
      .asBroadcastStream();

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

  Stream<PlayerChangeDto> playerChange$() => playersChangeData$
      .asBroadcastStream()
      .map((data) => _dataToPlayerChange(data));

  Stream<HitDto> hit$() =>
      hitData$.asBroadcastStream().map((data) => _dataToHit(data));

  late Stream<TeamsDto> teams$ = teamsData$.asBroadcastStream().map((data) {
    return _dataToTeams(data);
  });

  /*
  * Converters
  */

  PlayerChangeDto _dataToPlayerChange(String data) {
    final json = jsonDecode(data);
    final dto = PlayerChangeDto.fromJson(json);
    return dto;
  }

  HitDto _dataToHit(List<int> data) {
    final dto = HitDto(playerId: data[0], hp: data[1]);
    return dto;
  }

  // TODO add leaving game after dead
  // int _dataToDead(List<int> data) {
  //   leaveGame();
  //   final attackingPlayerId = data[0];
  //   return attackingPlayerId;
  // }

  TeamsDto _dataToTeams(data) {
    final teams = TeamsDto.fromJson(jsonDecode(data));
    return teams;
  }

  @override
  Future onDispose() async {
    await Future.wait([
      addOrRemovePlayerChannel.sink.close(status.goingAway),
      hitChannel.sink.close(status.goingAway),
      positionsSubscription.cancel(),
      myPositionSubscription.cancel(),
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

  Stream<WebSocketChannel> channel(String Function(int) uriBuilder) {
    return id$.skipNull().map((id) {
      final uri = Uri.parse('ws://$host:$port${uriBuilder(id)}');
      final channel = WebSocketChannel.connect(uri);
      return channel;
    });
  }
}
