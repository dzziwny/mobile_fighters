import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';

import '../setup.dart';

Future<Response> connectHandler(Request request) async {
  final body = await request.readAsString();
  final json = jsonDecode(body);
  final dto = ConnectToServerDto.fromJson(json);

  var id = assignPlayerId(dto.guid);
  if (id == null) {
    return Response(
      HttpStatus.badRequest,
      body: 'Player could not be assigned an ID',
    );
  }

  guids[dto.guid] = id;
  final responseDto = ConnectFromServerDto(id: id);
  return Response.ok(jsonEncode(responseDto));
}

int? assignPlayerId(String guid) {
  for (var i = 0; i < maxPlayers; i++) {
    if (!playerMetadatas[i].isActive) {
      playerMetadatas[i].isActive = true;
      return i;
    }
  }

  return null;
}
