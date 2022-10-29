import 'dart:async';
import 'dart:convert';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';

import '../setup.dart';

Future<Response> leaveGameHandler(Request request) async {
  final body = await request.readAsString();
  final json = jsonDecode(body);
  final dto = LeaveGameDtoRequest.fromJson(json);

  final id = guids.remove(dto.guid);

  if (id == null) {
    return Response.ok(null);
  }

  removePlayer(id);

  return Response.ok(null);
}
