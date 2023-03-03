import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:vector_math/vector_math.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';
import 'on_connection.dart';

class PushConnection extends OnConnection {
  @override
  void onInit(int playerId, WebSocketChannel channel) {
    pushChannels.add(channel);
  }

  Timer? timer;

  @override
  void onData(int playerId, Uint8List data) {
    if (pushCooldowns[playerId] == true && timer?.isActive == true) {
      return;
    }

    pushCooldowns[playerId] = true;

    double angle = data.toDouble(1, 5);
    if (angle > pi || angle < -pi) {
      return;
    }

    double dx = data.toDouble(5, 9);
    if (dx > 5.0 || dx < -5.0) {
      return;
    }

    double dy = data.toDouble(9, 13);
    if (dy > 5.0 || dy < -5.0) {
      return;
    }

    playerPhysics[playerId]?.pushingForce = Vector2(dx, dy);
    playerPhysics[playerId]?.angle = angle;

    timer = Timer(Duration(milliseconds: pushCooldownMilisesconds), () {
      pushCooldowns[playerId] = false;
    });
  }
}
