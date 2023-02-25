import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';
import 'package:uuid/uuid.dart';
import 'package:vector_math/vector_math.dart';

import '../model/player_physics.dart';
import '../setup.dart';

Future<Response> createPlayerHandler(Request request) async {
  final body = await request.readAsString();
  final json = jsonDecode(body);
  final dto = CreatePlayerDtoRequest.fromJson(json);
  final player = createPlayer(dto);
  final response = CreatePlayerDtoResponse(id: player.id, team: player.team);

  return Response.ok(jsonEncode(response.toJson()));
}

Future<Response> createTestPlayerHandler(_) async {
  final guid = Uuid().v4().hashCode;
  createPlayer(
    CreatePlayerDtoRequest(guid: guid, nick: 'test', device: Device.pixel),
  );
  return Response.ok(null);
}

Player createPlayer(CreatePlayerDtoRequest dto) {
  final guid = dto.guid;
  var prevPlayer = players[guids[guid]];
  if (prevPlayer != null) {
    return prevPlayer;
  }

  final id = ++ids;
  final randomX = Random().nextInt((frameWidth).toInt()).toDouble();
  final randomY = Random().nextInt((frameHeight).toInt()).toDouble();
  final randomAngle = Random().nextInt(100) / 10.0;
  final physic = PlayerPhysics(Vector2(randomX, randomY))..angle = randomAngle;
  playerPhysics[id] = physic;
  playerHp[id] = 100;

  final team = _selectTeam();
  final player = Player(
    id: id,
    nick: dto.nick,
    team: team,
    device: dto.device,
  );

  teams[team]?[id] = player;

  players[id] = player;

  guids[guid] = id;
  sharePlayers();
  _sharePlayerCreated(id);
  _sharePlayerPosition(id, physic);
  shareTeams();
  return player;
}

Team _selectTeam() {
  final material = materialTeam.length;
  final cupertino = cupertinoTeam.length;
  final fluent = fluentTeam.length;
  if (fluent <= cupertino && fluent <= material) {
    return Team.fluent;
  }

  if (cupertino <= material && cupertino <= fluent) {
    return Team.cupertino;
  }

  return Team.material;
}

void _sharePlayerPosition(int id, PlayerPhysics physic) {
  final data = <int>[
    id,
    ...(ByteData(4)..setFloat32(0, physic.position.x)).buffer.asUint8List(),
    ...(ByteData(4)..setFloat32(0, physic.position.y)).buffer.asUint8List(),
    ...(ByteData(4)..setFloat32(0, physic.angle)).buffer.asUint8List(),
  ];

  gameDraws.add(() {
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
