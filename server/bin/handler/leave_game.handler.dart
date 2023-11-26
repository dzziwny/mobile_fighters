import 'dart:async';
import 'dart:convert';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';

import '../setup.dart';

Future<Response> leaveGameHandler(Request request) async {
  final body = await request.readAsString();
  final json = jsonDecode(body);
  final dto = LeaveGameDtoRequest.fromJson(json);

  final id = guids[dto.guid];
  if (id == null || id != dto.id) {
    return Response.ok(null);
  }

  removePlayer(id, dto.guid);
  return Response.ok(null);
}
