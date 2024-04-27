import 'dart:async';
import 'dart:convert';

import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';

import '../game_setup.dart';

Future<Response> leaveGameHandler(Request request) async {
  final setup = GetIt.I<GameSetup>();

  final body = await request.readAsString();
  final json = jsonDecode(body);
  final dto = LeaveGameDtoRequest.fromJson(json);
  final id = setup.guids[dto.guid];
  if (id == null || id != dto.id) {
    return Response.ok(null);
  }

  setup.removePlayer(id);
  return Response.ok(null);
}
