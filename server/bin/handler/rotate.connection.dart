import 'dart:math';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'channels.handler.dart';
import '../inputs/knob.input.dart';
import 'on_connection.dart';

class RotateConnection extends OnConnection {
  final knobInput = GetIt.I<KnobInput>();
  final channelsHandler = GetIt.I<ChannelsHandler>();

  @override
  void onInit(int playerId, WebSocketChannel channel) {}

  @override
  void onData(int playerId, Uint8List data) {
    double angle = data.toDouble(0, 4);
    if (angle > pi || angle < -pi) {
      return;
    }

    knobInput.updateAngle(playerId, angle);
  }
}
