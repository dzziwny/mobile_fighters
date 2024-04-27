import 'dart:async';
import 'dart:convert';

import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';

import '../ammunition/bomb_loop.dart';
import '../ammunition/bullet_loop.dart';
import '../ammunition/dash_loop.dart';
import '../game_runner.dart';
import '../game_setup.dart';

Future<Response> setGameSettingsHandler(Request request) async {
  final runner = GetIt.I<GameRunner>();

  final body = await request.readAsString();
  final json = jsonDecode(body);
  gameSettings = GameSettings.fromJson(json);
  for (var player in players) {
    player.resetGamePhysics();
  }

  bulletsLoop = getBulletLoop();
  bombsLoop = getBombLoop();
  dashLoop = getDashLoop();
  runner.restartGameCycleTimer();
  runner.restartDrawTimer();

  return Response.ok(null);
}
