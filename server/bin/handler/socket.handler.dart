import 'dart:math';
import 'dart:typed_data';

import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';

void socketHandler(WebSocketChannel channel) {
  channels.add(channel);

  channel.stream.listen((data) {
    double angle = ByteData.sublistView(Uint8List.fromList(data.sublist(1, 5)))
        .getFloat32(0);
    if (angle > pi || angle < -pi) {
      return;
    }

    double deltaX = ByteData.sublistView(Uint8List.fromList(data.sublist(5, 9)))
        .getFloat32(0);
    if (deltaX > 50 || deltaX < -50) {
      return;
    }

    double deltaY =
        ByteData.sublistView(Uint8List.fromList(data.sublist(9, 13)))
            .getFloat32(0);
    if (deltaY > 50 || deltaY < -50) {
      return;
    }

    final playerId = data[0];
    playerKnobs[playerId] = [deltaX, deltaY, angle];
  });
}
