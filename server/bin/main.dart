import 'dart:async';
import 'dart:io';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';

import 'bomb.physic.dart';
import 'bomb_loop.dart';
import 'bullet.physic.dart';
import 'bullet_loop.dart';
import 'handler/_handler.dart';
import 'handler/game_data.connection.dart';
import 'handler/mobile_controls.connection.dart';
import 'handler/on_connection.dart';
import 'register_di.dart';
import 'setup.dart';
import 'updates/_updates.dart';

int lastUpdateTime = DateTime.now().microsecondsSinceEpoch;
int accumulatorTime = 0;

extension WithWeb on Router {
  void ws(Socket endpoint, OnConnection onConnection) =>
      get(endpoint.route(), onConnection.handler());
}

void main(List<String> args) async {
  // final ip = InternetAddress.anyIPv4;
  final ip = '0.0.0.0';

  final router = Router()
    ..get(Endpoint.gameFrame, gameFrameHandler)
    ..post(Endpoint.connect, connectHandler)
    ..post(Endpoint.startGame, createPlayerHandler)
    ..post(Endpoint.leaveGame, leaveGameHandler)
    ..post(Endpoint.setGamePhysics, setGamePhysicsHandler)
    ..ws(Socket.mobilePlayerStateWs, MobileControlsConnection())
    ..ws(Socket.desktopPlayerStateWs, DesktopControlsConnection())
    ..ws(Socket.gameDataWs, GameDataConnection())
    ..ws(Socket.gameStateWs, GameStateConnection())
    ..ws(Socket.actionsWs, ActionsConnection());

  final handler = Pipeline()
      // .addMiddleware(
      //   logRequests(),
      // )
      .addMiddleware(corsHeaders())
      .addHandler(router);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on ${server.address.host}:${server.port}');

  Timer.periodic(frameRate, (_) {
    final now = DateTime.now().microsecondsSinceEpoch;
    final dt = now - lastUpdateTime;
    lastUpdateTime = now;
    accumulatorTime += dt;
    while (accumulatorTime > sliceTimeMicroseconds) {
      update();
      accumulatorTime -= sliceTimeMicroseconds;
    }

    draw();
  });
}

void update() {
  _executeActions();
  _physicUpdate();
}

void _executeActions() {
  for (var i = 0; i < maxPlayers; i++) {
    bulletsLoop.toggle(i, playerInputs[i].isBullet);
    bombsLoop.toggle(i, playerInputs[i].isBomb);
  }
}

void _physicUpdate() {
  for (var i = 0; i < maxBullets; i++) {
    bulletPhysicUpdate(bullets[i], sliceTimeSeconds);
  }

  for (var i = 0; i < maxBombs; i++) {
    bombPhysicUpdate(bombs[i], sliceTimeSeconds);
  }

  for (var i = 0; i < maxPlayers; i++) {
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

  // TODO
  // bombs = [];
  // hits = [];

  for (var channel in gameStateChannels) {
    channel.sink.add(bytes);
  }
}
