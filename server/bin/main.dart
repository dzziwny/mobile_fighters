import 'dart:async';
import 'dart:io';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

import 'router.dart';
import 'setup.dart';
import 'updates/_updates.dart';

int lastUpdateTime = DateTime.now().microsecondsSinceEpoch;
int accumulatorTime = 0;

void main(List<String> args) async {
  // final ip = InternetAddress.anyIPv4;
  final ip = '0.0.0.0';

  final handler = Pipeline()
      // .addMiddleware(
      //   logRequests(),
      // )
      .addHandler(router);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');

  Timer.periodic(Duration.zero, (_) {
    final now = DateTime.now().microsecondsSinceEpoch;
    final dt = now - lastUpdateTime;
    lastUpdateTime = now;
    accumulatorTime += dt;
    while (accumulatorTime > sliceTime) {
      update();
      accumulatorTime -= sliceTime;
    }
    draw();
  });
}

void update() {
  // TODO: add attack, add position
  for (var i = 0; i < gameUpdates.length; i++) {
    final func = gameUpdates.removeAt(0);
    func();
  }

  for (var playerId in players.keys) {
    positionUpdate(playerId);
  }
}

void draw() {
  for (var i = 0; i < gameDraws.length; i++) {
    final func = gameDraws.removeAt(0);
    func();
  }
}
