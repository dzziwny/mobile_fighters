import 'dart:async';
import 'dart:convert';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';

import '../ammunition/bomb_loop.dart';
import '../ammunition/bullet_loop.dart';
import '../ammunition/dash_loop.dart';
import '../main.dart';
import '../setup.dart';

Future<Response> setGameSettingsHandler(Request request) async {
  final body = await request.readAsString();
  final json = jsonDecode(body);
  gameSettings = GameSettings.fromJson(json);
  for (var player in players) {
    player.resetGamePhysics();
  }

  bulletsLoop = getBulletLoop();
  bombsLoop = getBombLoop();
  dashLoop = getDashLoop();
  restartGameCycleTimer();
  restartDrawTimer();

  return Response.ok(null);
}
