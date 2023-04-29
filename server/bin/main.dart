import 'dart:async';
import 'dart:io';

import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';

import 'handler/_handler.dart';
import 'handler/knob.input.dart';
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
    ..ws(Socket.fragWs, DeadConnection())
    ..ws(Socket.selectTeamWs, TeamConnection())
    ..ws(Socket.gamePhaseWsTemplate, GamePhaseConnection())
    ..ws(Socket.playersWs, PlayersConnection())
    ..ws(Socket.playerChangeWs, PlayerChangeConnection())
    ..ws(Socket.hitWs, HitConnection());

  final handler = Pipeline()
      // .addMiddleware(
      //   logRequests(),
      // )
      .addMiddleware(corsHeaders())
      .addHandler(router);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on ${server.address.host}:${server.port}');

  Timer.periodic(Duration.zero, (_) {
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

Future<void> update() async {
  await _CRUDsUpdate();
  await _actionsUpdate();
  await _physicUpdate();
}

Future<void> _CRUDsUpdate() async {
  // TODO
}

Future<void> _actionsUpdate() async {
  for (var i = 0; i < gameUpdates.length; i++) {
    final func = gameUpdates.removeAt(0);
    await func();
  }
}

Future<void> _physicUpdate() async {
  final knobInput = GetIt.I<KnobInput>();

  final updates = players.keys.map((id) {
    final x = knobInput.x(id);
    final y = knobInput.y(id);
    final angle = knobInput.angle(id);

    return physicUpdate(id, x, y, angle);
  });
  await Future.wait(updates);
}

void draw() {
  for (var i = 0; i < gameDraws.length; i++) {
    final func = gameDraws.removeAt(0);
    func();
  }
}
