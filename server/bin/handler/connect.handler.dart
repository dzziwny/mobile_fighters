import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';

import '../setup.dart';

Future<Response> connectHandler(Request request) async {
  final body = await request.readAsString();
  final json = jsonDecode(body);
  final dto = ConnectToServerDto.fromJson(json);
  final guidId = guids[dto.guid];
  if (guidId != null) {
    return Response.ok(
      jsonEncode(
        ConnectFromServerDto(
          id: guidId,
          reconnected: true,
        ),
      ),
    );
  }

  var id = assignPlayerId();
  if (id == null) {
    return Response(
      HttpStatus.badRequest,
      body: 'Player could not be assigned an ID',
    );
  }

  guids[dto.guid] = id;
  final responseDto = ConnectFromServerDto(id: id, reconnected: false);
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
