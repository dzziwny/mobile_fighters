import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';

import 'router.dart';
import 'setup.dart';

double maxSpeed = 0.00001;

void schedulePlayerPositionUpdate(int playerId, int time) {
  final knob = playerKnobs[playerId] ?? [];
  assert(knob.isNotEmpty);

  final deltaX = knob[0];
  final deltaY = knob[1];
  final angle = knob[2];

  final oldPosition = playerPositions[playerId] ?? [];
  assert(oldPosition.isNotEmpty);

  final valuex = deltaX * maxSpeed * sliceTime + oldPosition[0];
  final valuey = deltaY * maxSpeed * sliceTime + oldPosition[1];

  playerPositions[playerId] = [valuex, valuey, angle];
  playerPositionUpdates[playerId] = <int>[
    1,
    playerId,
    ...(ByteData(4)..setFloat32(0, valuex)).buffer.asUint8List(),
    ...(ByteData(4)..setFloat32(0, valuey)).buffer.asUint8List(),
    ...(ByteData(4)..setFloat32(0, angle)).buffer.asUint8List(),
  ];
}

int lastUpdateTime = DateTime.now().microsecondsSinceEpoch;
int accumulatorTime = 0;

// If there are lags, try make sliceTime smaller
const int sliceTime = 5000;

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
      update(sliceTime);
      accumulatorTime -= sliceTime;
    }
    draw();
  });
}

void update(int time) {
  for (var playerId in players.values) {
    schedulePlayerPositionUpdate(playerId, time);
  }
}

void draw() {
  for (var position in playerPositionUpdates.values) {
    for (var channel in channels) {
      channel.sink.add(position);
    }
  }
}
