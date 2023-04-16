import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:math';

import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';
import 'package:vector_math/vector_math.dart';

import '../model/player_physics.dart';
import '../setup.dart';
import 'channels.handler.dart';

void playerPosition(SendPort sendPort) async {
  final receivePort = ReceivePort();
  sendPort.send(receivePort.sendPort);
  final receiveStream = receivePort.asBroadcastStream();
  final Team team = await receiveStream.first;
  var x = Random().nextInt((respawnWidth).toInt()).toDouble();
  if (team == Team.red) {
    x = boardWidth - x;
  }

  final y = Random().nextInt((boardHeight).toInt()).toDouble();
  final angle = Random().nextInt(100) / 10.0;
  final position = Position(x: x, y: y, angle: angle);
  sendPort.send(position);
  receiveStream.listen((data) {});
}

Future<Response> createPlayerHandler(Request request) async {
  final body = await request.readAsString();
  final json = jsonDecode(body);
  final dto = CreatePlayerDtoRequest.fromJson(json);
  final player = await createPlayer(dto);

  final response = CreatePlayerDtoResponse(
    id: player.id,
    team: player.team,
    position: player.position,
    hp: startHp,
  );

  return Response.ok(jsonEncode(response));
}

Future<Player> createPlayer(CreatePlayerDtoRequest dto) async {
  final id = guids[dto.guid];
  if (id == null || id != dto.id) {
    throw Exception();
  }

  var prevPlayer = players[id];
  if (prevPlayer != null) {
    return prevPlayer;
  }

  final team = _selectTeam();

  final receivePort = ReceivePort();
  final receiveStream = receivePort.asBroadcastStream();
  final sendPort$ = receiveStream.first;
  final isolate = await Isolate.spawn(playerPosition, receivePort.sendPort);
  final sendPort = await sendPort$ as SendPort;
  sendPort.send(team);
  final Position position = await receiveStream.first;

  final physic = PlayerPhysics(Vector2(position.x, position.y))
    ..angle = position.angle;
  playerPhysics[id] = physic;

  final player = Player(
    id: id,
    nick: dto.nick,
    team: team,
    device: dto.device,
    position: PlayerPosition(
      playerId: id,
      x: position.x,
      y: position.y,
      angle: position.angle,
    ),
    hp: startHp,
  );

  teams[team]?[id] = player;

  players[id] = player;

  sharePlayers();
  _sharePlayerCreated(id);
  _sharePlayerPosition(id, physic);
  shareTeams();
  return player;
}

Team _selectTeam() => blueTeam.length <= redTeam.length ? Team.blue : Team.red;

void _sharePlayerPosition(int id, PlayerPhysics physic) {
  final data = <int>[
    id,
    ...physic.position.x.toBytes(),
    ...physic.position.y.toBytes(),
    ...physic.angle.toBytes(),
  ];

  gameDraws.add(() async {
    final pushChannels = await GetIt.I<ChannelsHandler>().getPushChannel();
    for (var channel in pushChannels) {
      channel.sink.add(data);
    }
  });
}

void _sharePlayerCreated(int id) {
  final player = players[id];
  if (player == null) {
    return;
  }

  final dto = PlayerChangeDto(
    id: id,
    nick: player.nick,
    type: PlayerChangeType.added,
    team: player.team,
  );

  final data = jsonEncode(dto);
  for (final channel in playerChangeWSChannels) {
    channel.sink.add(data);
  }
}
