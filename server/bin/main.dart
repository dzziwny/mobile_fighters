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
  final ip = InternetAddress.anyIPv4;

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
  for (var i = 0; i < gameUpdates.length; i++) {
    final data = gameUpdates.removeAt(0);
    final type = data[0];
    switch (type) {
      case 1:
        attackUpdate(data);
        break;
      default:
        assert(false, 'Unknown update type');
    }
  }

  for (var playerId in players.keys) {
    // TODO: change it to not update position every time
    positionUpdate(playerId);
  }
}

void draw() {
  for (var i = 0; i < gameDraws.length; i++) {
    final func = gameDraws.removeAt(0);
    func();
  }

  // TODO: change it to not draw position every time
  positionDraw();
}

void positionDraw() {
  for (var position in playerPositionUpdates.values) {
    for (var channel in rawDataWSChannels) {
      channel.sink.add(position);
    }
  }
}
