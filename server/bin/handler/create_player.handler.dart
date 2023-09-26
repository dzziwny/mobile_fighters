import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';

import '../setup.dart';

Future<Response> createPlayerHandler(Request request) async {
  final body = await request.readAsString();
  final json = jsonDecode(body);
  final dto = CreatePlayerDtoRequest.fromJson(json);
  await createPlayer(dto);

  return Response(204);
}

Future<void> createPlayer(CreatePlayerDtoRequest dto) async {
  final id = guids[dto.guid];
  if (id == null || id != dto.id) {
    throw Exception();
  }

  var prevPlayer = playerMetadatas[id];
  if (prevPlayer.isActive) {
    return;
  }

  final team = _selectTeam();
  var x = Random().nextInt(respawnWidth);
  if (team == Team.red) {
    x = boardWidth - x;
  }

  final y = Random().nextInt(boardHeight);
  final angle = Random().nextInt(100) / 10.0;

  players[id]
    ..x = x.toDouble()
    ..y = y.toDouble()
    ..angle = angle
    ..isBombCooldown = 0
    ..isDashCooldown = 0
    ..nick = dto.nick
    ..team = team
    ..device = dto.device
    ..hp = startHpDouble;

  shareGameData();
}

Team _selectTeam() => blueTeam.length <= redTeam.length ? Team.blue : Team.red;
