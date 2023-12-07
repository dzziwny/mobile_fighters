import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';

import '../setup.dart';

Future<Response> playHandler(Request request) async {
  final body = await request.readAsString();
  final json = jsonDecode(body);
  final dto = PlayToServerDto.fromJson(json);
  final guidId = guids[dto.guid];
  if (guidId != null) {
    return Response.ok(jsonEncode(PlayFromServerDto(id: guidId)));
  }

  var id = assignPlayerId();
  if (id == null) {
    return Response(
      HttpStatus.badRequest,
      body: 'Player could not be assigned an ID',
    );
  }

  guids[dto.guid] = id;
  await _createPlayer(id, dto);
  final responseDto = PlayFromServerDto(id: id);
  return Response.ok(jsonEncode(responseDto));
}

int? assignPlayerId() {
  for (var i = 0; i < gameSettings.maxPlayers; i++) {
    if (!playerMetadatas[i].isActive) {
      playerMetadatas[i].isActive = true;
      return i;
    }
  }

  return null;
}

Future<void> _createPlayer(int id, PlayToServerDto dto) async {
  final team = _selectTeam(id);
  var x = Random().nextInt(gameSettings.respawnWidth);
  if (team == Team.red) {
    x = gameSettings.battleGroundWidth - x;
  }

  final y = Random().nextInt(gameSettings.battleGroundHeight);
  final angle = Random().nextInt(100) / 10.0;

  players[id]
    ..x = x.toDouble()
    ..y = y.toDouble()
    ..angle = angle
    ..isBombCooldownBit = 0
    ..isDashCooldownBit = 0
    ..nick = dto.nick
    ..team = team
    ..device = dto.device
    ..hp = gameSettings.playerStartHp
    ..isActive = true;

  shareGameData();
}

Team _selectTeam(int id) => id.isEven ? Team.blue : Team.red;
