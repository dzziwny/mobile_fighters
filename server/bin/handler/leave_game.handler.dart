import 'dart:async';
import 'dart:convert';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';

import '../setup.dart';

Future<Response> leaveGameHandler(Request request) async {
  final body = await request.readAsString();
  final json = jsonDecode(body);
  final dto = LeaveGameDtoRequest.fromJson(json);

  final serverId = guids[dto.guid];
  if (serverId == null || serverId != dto.id) {
    return Response.ok(null);
  }

  removePlayer(serverId);
  return Response.ok(null);
}
