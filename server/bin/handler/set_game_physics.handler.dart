import 'dart:async';
import 'dart:convert';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';

import '../setup.dart';

Future<Response> setGamePhysicsHandler(Request request) async {
  final body = await request.readAsString();
  final json = jsonDecode(body);
  final physics = GamePhysics.fromJson(json);

  gamePhysics.f = physics.f;
  gamePhysics.k = physics.k;
  gamePhysics.n = physics.n;

  for (var player in players) {
    player.resetGamePhysics();
  }

  return Response.ok(null);
}
