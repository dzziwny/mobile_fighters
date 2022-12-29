import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';
import 'package:uuid/uuid.dart';

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
  playerPositions[id] = [randomX, randomY, 0.0];
  playerKnobs[id] = [0.0, 0.0, 0.0];
  playerSpeed[id] = normalSpeed;
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
