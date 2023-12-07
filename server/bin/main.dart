import 'dart:async';
import 'dart:io';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';

import 'ammunition/ammunition.physic.dart';
import 'ammunition/bomb_loop.dart';
import 'ammunition/bullet_loop.dart';
import 'ammunition/dash_loop.dart';
import 'controls/desktop_controls.connection.dart';
import 'controls/mobile_controls.connection.dart';
import 'handler/_handler.dart';
import 'handler/connect.handler.dart';
import 'handler/game_data.connection.dart';
import 'handler/on_connection.dart';
import 'register_di.dart';
import 'setup.dart';
import 'updates/_updates.dart';

int _lastUpdateTime = DateTime.now().microsecondsSinceEpoch;
int _accumulatorTime = 0;

extension WithWeb on Router {
  void ws(Socket endpoint, OnConnection onConnection) =>
      get(endpoint.route(), onConnection.handler());
}

void main(List<String> args) async {
  final ip = '0.0.0.0';
  final router = Router()
    ..get('/ping', (Request req) => Response.ok('ping'))
    ..get(Endpoint.gameFrame, gameFrameHandler)
    ..post(Endpoint.connect, connectHandler)
    ..post(Endpoint.play, playHandler)
    ..post(Endpoint.leaveGame, leaveGameHandler)
    ..post(Endpoint.setGameSettings, setGameSettingsHandler)
    ..ws(Socket.mobileControlsWs, MobileControlsConnection())
    ..ws(Socket.desktopControlsWs, DesktopControlsConnection())
    ..ws(Socket.gameDataWs, GameDataConnection())
    ..ws(Socket.gameStateWs, GameStateConnection());

  final handler =
      Pipeline().addMiddleware(corsHeaders()).addHandler(router.call);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on ${server.address.host}:${server.port}');
  restartGameTimer();
}

Timer? _timer;
// used when user changes settings manually
void restartGameTimer() {
  _timer?.cancel();
  var frameRate = Duration(milliseconds: gameSettings.frameRate);
  _timer = Timer.periodic(frameRate, (_) => _gameCycle());
}

void _gameCycle() {
  final now = DateTime.now().microsecondsSinceEpoch;
  final dt = now - _lastUpdateTime;
  _lastUpdateTime = now;
  _accumulatorTime += dt;
  while (_accumulatorTime > gameSettings.sliceTimeMicroseconds) {
    update();
    _accumulatorTime -= gameSettings.sliceTimeMicroseconds;
  }

  draw();
}

void update() {
  _executeActions();
  _physicUpdate();
}

void _executeActions() {
  for (var i = 0; i < gameSettings.maxPlayers; i++) {
    bulletsLoop.toggle(i, playerInputs[i].isBullet);
    bombsLoop.toggle(i, playerInputs[i].isBomb);
    dashLoop.toggle(i, playerInputs[i].isDash);
  }
}

void _physicUpdate() {
  for (var i = 0; i < gameSettings.maxBullets; i++) {
    ammunitionPhysicUpdate(
      ammo: bullets[i],
      dt: gameSettings.sliceTimeSeconds,
      maxDistance: gameSettings.bulletDistanceSquared,
      hitDistance: gameSettings.bulletPlayerCollisionDistanceSquare,
      power: gameSettings.bulletPower,
    );
  }

  for (var i = 0; i < gameSettings.maxBombs; i++) {
    ammunitionPhysicUpdate(
      ammo: bombs[i],
      dt: gameSettings.sliceTimeSeconds,
      maxDistance: gameSettings.bombDistanceSquared,
      hitDistance: gameSettings.bombPlayerCollisionDistanceSquare,
      power: gameSettings.bombPower,
    );
  }

  for (var i = 0; i < gameSettings.maxPlayers; i++) {
    playerPhysicUpdate(playerInputs[i]);
  }
}

void draw() {
  final bytes = GameState.bytes(
    players,
    bombs,
    hits,
    bullets,
    frags,
  );

  hits.fillRange(0, gameSettings.maxPlayers.bitLength, 0);

  for (var channel in gameStateChannels) {
    channel.sink.add(bytes);
  }
}
