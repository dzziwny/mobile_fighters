import 'dart:math';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'channels.handler.dart';
import 'knob.input.dart';
import 'on_connection.dart';

class PushConnection extends OnConnection {
  final knobInput = GetIt.I<KnobInput>();
  final channelsHandler = GetIt.I<ChannelsHandler>();

  @override
  void onInit(int playerId, WebSocketChannel channel) {
    channelsHandler.addPushChannel(playerId, channel);
  }

  @override
  void onData(int playerId, Uint8List data) {
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

    final knob = Knob(dx, dy, angle);

    knobInput.update(playerId, knob);
  }
}
