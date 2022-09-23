import 'dart:typed_data';

import '../setup.dart';

void attackUpdate(List<int> data) {
  final attackingPlayerId = data[1];
  final targets = Map<int, List<double>>.from(playerPositions);
  final position = targets.remove(attackingPlayerId);
  if (position == null) {
    return;
  }

  final x = position[0];
  final y = position[1];
  final angle = position[2];
  final frame = <int>[
    attackingPlayerId,
    ...(ByteData(4)..setFloat32(0, x)).buffer.asUint8List(),
    ...(ByteData(4)..setFloat32(0, y)).buffer.asUint8List(),
    ...(ByteData(4)..setFloat32(0, angle)).buffer.asUint8List(),
  ];

  gameDraws.add((() {
    for (var channel in attackWSChannels) {
      channel.sink.add(frame);
    }
  }));
}
