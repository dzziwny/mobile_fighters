import 'dart:typed_data';

import '../setup.dart';

double _resolveX(double delta, double maxSpeed, int sliceTime, double oldX) {
  var newX = delta * maxSpeed * sliceTime + oldX;
  if (newX > maxX) {
    return maxX;
  }

  if (newX < minX) {
    return minX;
  }

  return newX;
}

double _resolveY(double delta, double maxSpeed, int sliceTime, double oldY) {
  var newY = delta * maxSpeed * sliceTime + oldY;
  if (newY > maxY) {
    return maxY;
  }

  if (newY < minY) {
    return minY;
  }

  return newY;
}

void positionUpdate(int playerId) {
  final knob = playerKnobs[playerId] ?? [];
  assert(knob.isNotEmpty);

  final deltaX = knob[0];
  final deltaY = knob[1];
  final angle = knob[2];
  final oldPosition = playerPositions[playerId]!;
  final speed = playerSpeed[playerId]!;

  var valuex = _resolveX(deltaX, speed, sliceTime, oldPosition[0]);
  var valuey = _resolveY(deltaY, speed, sliceTime, oldPosition[1]);

  playerPositions[playerId] = [valuex, valuey, angle];
  final data = <int>[
    playerId,
    ...(ByteData(4)..setFloat32(0, valuex)).buffer.asUint8List(),
    ...(ByteData(4)..setFloat32(0, valuey)).buffer.asUint8List(),
    ...(ByteData(4)..setFloat32(0, angle)).buffer.asUint8List(),
  ];

  gameDraws.add(() {
    for (var channel in rawDataWSChannels) {
      channel.sink.add(data);
    }
  });
}
