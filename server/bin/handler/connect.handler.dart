import 'dart:convert';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';

import '../setup.dart';

Future<Response> connectHandler(Request request) async {
  final body = await request.readAsString();
  final json = jsonDecode(body);
  final dto = ConnectToServerDto.fromJson(json);
  var id = guids[dto.guid];
  if (id != null) {
    return Response.ok(jsonEncode(ConnectFromServerDto(id: id)));
  }

  for (var i = 0; i < maxPlayers; i++) {
    if (!playerMetadatas[i].isActive) {
      id = i;
    }
  }

  if (id == null) {
    return Response.badRequest();
  }

  guids[dto.guid] = id;
  final responseDto = ConnectFromServerDto(id: id);

  final data = jsonEncode(responseDto);
  return Response.ok(data);
}
