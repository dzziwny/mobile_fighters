import 'dart:convert';

import 'package:shelf/shelf.dart';

import '../setup.dart';

Future<Response> getPlayersHandler(Request request) async {
  final data = jsonEncode(players.values.toList());
  return Response.ok(data);
}
