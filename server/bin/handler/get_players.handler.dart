import 'dart:convert';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';

import '../setup.dart';

Future<Response> getPlayersHandler(Request request) async {
  final body = jsonEncode(GetPlayersDtoResponse(players: guids).toJson());
  return Response.ok(body);
}
