import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';

import '../setup.dart';

Future<Response> connectHandler(Request request) async {
  final body = await request.readAsString();
  final json = jsonDecode(body);
  final dto = ConnectToServerDto.fromJson(json);
  final guidId = guids[dto.guid];
  if (guidId != null) {
    return Response.ok(jsonEncode(ConnectFromServerDto(id: guidId)));
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
  final responseDto = ConnectFromServerDto(id: id);
  return Response.ok(jsonEncode(responseDto));
}

int? assignPlayerId() {
  for (var i = 0; i < maxPlayers; i++) {
    if (!playerMetadatas[i].isActive) {
      playerMetadatas[i].isActive = true;
      return i;
    }
  }

  return null;
}

Future<void> _createPlayer(int id, ConnectToServerDto dto) async {
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
    ..isBombCooldownBit = 0
    ..isDashCooldownBit = 0
    ..nick = dto.nick
    ..team = team
    ..device = dto.device
    ..hp = startHp
    ..isActive = true;

  shareGameData();
}

Team _selectTeam(int id) => id.isEven ? Team.blue : Team.red;
