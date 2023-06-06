import 'dart:async';
import 'dart:io';

import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';

import 'handler/_handler.dart';
import 'handler/channels.handler.dart';
import 'inputs/knob.input.dart';
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

  registerDI();

  final router = Router()
    ..get(Endpoint.gameFrame, gameFrameHandler)
    ..post(Endpoint.connect, connectHandler)
    ..post(Endpoint.startGame, createPlayerHandler)
    ..post(Endpoint.leaveGame, leaveGameHandler)
    ..ws(Socket.pushWs, PushConnection())
    ..ws(Socket.rotateWs, RotateConnection())
    ..ws(Socket.movementKeyboardhWs, MovementKeyboardConnection())
    ..ws(Socket.dashWs, DashConnection())
    ..ws(Socket.cooldownWs, CooldownConnection())
    ..ws(Socket.attackWs, AttackConnection())
    ..ws(Socket.bulletWs, BulletConnection())
    ..ws(Socket.fragWs, DeadConnection())
    ..ws(Socket.selectTeamWs, TeamConnection())
    ..ws(Socket.gamePhaseWsTemplate, GamePhaseConnection())
    ..ws(Socket.playersWs, PlayersConnection())
    ..ws(Socket.playerChangeWs, PlayerChangeConnection())
    ..ws(Socket.hitWs, HitConnection())
    ..ws(Socket.gameStateWs, GameStateConnection());

  final handler = Pipeline()
      // .addMiddleware(
      //   logRequests(),
      // )
      .addMiddleware(corsHeaders())
      .addHandler(router);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on ${server.address.host}:${server.port}');

  // Set the desired frame rate (e.g., 60 frames per second)
  final frameRate = Duration(milliseconds: 1000 ~/ 60);

  Timer.periodic(frameRate, (_) async {
    final now = DateTime.now().microsecondsSinceEpoch;
    final dt = now - lastUpdateTime;
    lastUpdateTime = now;
    accumulatorTime += dt;
    while (accumulatorTime > sliceTimeMicroseconds) {
      await update();
      accumulatorTime -= sliceTimeMicroseconds;
    }

    await draw();
  });
}

Future<void> update() async {
  await _CRUDsUpdate();
  await _actionsUpdate();
  await _physicUpdate();
}

Future<void> _CRUDsUpdate() async {
  // TODO
}

Future<void> _actionsUpdate() async {
  for (var i = 0; i < actions.length; i++) {
    final action = actions.removeAt(0);
    await action.handle();
  }
}

Future<void> _physicUpdate() async {
  await Future.wait([
    _bulletsPhysicUpdate(),
    _playersPhysicUpdate(),
  ]);
}

Future<void> _bulletsPhysicUpdate() async {
  final updates = bullets.values.map(
    (bullet) => bulletPhysicUpdate(bullet, sliceTimeSeconds),
  );

  await Future.wait(updates);
}

Future<void> _playersPhysicUpdate() async {
  final knobInput = GetIt.I<KnobInput>();

  final updates = players.keys.map((id) {
    final x = knobInput.x(id);
    final y = knobInput.y(id);
    final angle = knobInput.angle(id);

    return playerPhysicUpdate(id, x, y, angle);
  });

  await Future.wait(updates);
}

Future<void> draw() async {
  final bytes = GameState.bytes(
    playerPhysics.entries,
    bombAttackResponses,
    hits,
    bullets.values,
  );

  bombAttackResponses = [];
  hits = [];

  final channels = await GetIt.I<ChannelsHandler>().getGameStateChannels();
  for (var channel in channels) {
    channel.sink.add(bytes);
  }
}
