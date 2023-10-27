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

  final team = _selectTeam(id);
  var x = Random().nextInt(respawnWidth);
  if (team == Team.red) {
    x = battleGroundWidth - x;
  }

  final y = Random().nextInt(battleGroundHeight);
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
    ..hp = startHp
    ..isActive = true;

  shareGameData();
}

Team _selectTeam(int id) => id.isEven ? Team.blue : Team.red;
