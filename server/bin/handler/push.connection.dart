import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:vector_math/vector_math.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';
import 'on_connection.dart';

class PushConnection extends OnConnection {
  @override
  void onInit(int playerId, WebSocketChannel channel) {
    pushChannels.add(channel);
  }

  @override
  void onData(int playerId, List<int> data) {
    if (pushCooldowns[playerId] == true) {
      return;
    }
    pushCooldowns[playerId] = true;

    double angle = ByteData.sublistView(Uint8List.fromList(data.sublist(1, 5)))
        .getFloat32(0);
    if (angle > pi || angle < -pi) {
      return;
    }

    double dx = ByteData.sublistView(Uint8List.fromList(data.sublist(5, 9)))
        .getFloat32(0);
    if (dx > 1.0 || dx < -1.0) {
      return;
    }

    double dy = ByteData.sublistView(Uint8List.fromList(data.sublist(9, 13)))
        .getFloat32(0);
    if (dy > 1.0 || dy < -1.0) {
      return;
    }

    //TODO: simplify calculations here and calculation on player joystic
    playerPhysics[playerId]?.pushingForce = Vector2(dx, dy) * 5.0;
    playerPhysics[playerId]?.angle = angle;

    Timer(Duration(milliseconds: pushCooldownMilisesconds), () {
      pushCooldowns[playerId] = false;
    });
  }
}
