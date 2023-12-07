import 'dart:async';
import 'dart:convert';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';

import '../main.dart';
import '../setup.dart';

Future<Response> setGameSettingsHandler(Request request) async {
  final body = await request.readAsString();
  final json = jsonDecode(body);
  gameSettings = GameSettings.fromJson(json);
  for (var player in players) {
    player.resetGamePhysics();
  }

  restartGameTimer();

  return Response.ok(null);
}
