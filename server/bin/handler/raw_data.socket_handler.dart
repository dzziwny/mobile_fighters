import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';

void rawDataSocketHandler(WebSocketChannel channel) {
  rawDataWSChannels.add(channel);

  channel.stream.listen((data) {
    switch (data[0]) {
      case 0:
        updateKnob(data);
        break;
      case 1:
        dash(data);
        break;
      default:
        assert(false);
    }
  });
}

void updateKnob(List<int> data) {
  final playerId = data[1];
  double angle = ByteData.sublistView(Uint8List.fromList(data.sublist(2, 6)))
      .getFloat32(0);
  if (angle > pi || angle < -pi) {
    return;
  }

  double deltaX = ByteData.sublistView(Uint8List.fromList(data.sublist(6, 10)))
      .getFloat32(0);
  if (deltaX > 50 || deltaX < -50) {
    return;
  }

  double deltaY = ByteData.sublistView(Uint8List.fromList(data.sublist(10, 14)))
      .getFloat32(0);
  if (deltaY > 50 || deltaY < -50) {
    return;
  }

  playerKnobs[playerId] = [deltaX, deltaY, angle];
}

final Map<int, bool> _dashCooldowns = {};

void dash(List<int> data) {
  final playerId = data[1];
  if (_dashCooldowns[playerId] == true) {
    return;
  }

  playerSpeed[playerId] = dashSpeed;
  _dashCooldowns[playerId] = true;
  Timer.periodic(Duration(milliseconds: 200), (timer) {
    playerSpeed[playerId] = normalSpeed;
    timer.cancel();
  });

  Timer.periodic(Duration(seconds: 1), (timer) {
    _dashCooldowns[playerId] = false;
    timer.cancel();
  });
}
