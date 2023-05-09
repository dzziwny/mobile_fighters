import 'dart:math';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'channels.handler.dart';
import '../inputs/knob.input.dart';
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

    double x = data.toDouble(5, 9);
    if (x > 5.0 || x < -5.0) {
      return;
    }

    double y = data.toDouble(9, 13);
    if (y > 5.0 || y < -5.0) {
      return;
    }

    knobInput.update(playerId, x, y, angle);
  }
}
