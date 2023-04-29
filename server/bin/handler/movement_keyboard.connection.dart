import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'channels.handler.dart';
import 'knob.input.dart';
import 'on_connection.dart';

class MovementKeyboardConnection extends OnConnection {
  final knobInput = GetIt.I<KnobInput>();
  final channelsHandler = GetIt.I<ChannelsHandler>();

  @override
  void onInit(int playerId, WebSocketChannel channel) {}

  @override
  void onData(int playerId, Uint8List data) {
    if (data.isEmpty) {
      return;
    }

    final state = data[0];

    double x = 0.0;
    final xBits = state;
    // 0x11 & 0x10
    if (xBits & 0x3 == 0x2) {
      x = -5.0;
    }

    // 0x11 & 0x01
    else if (xBits & 0x3 == 0x1) {
      x = 5.0;
    }

    double y = 0.0;
    final yBits = state >> 2;
    // 0x11 & 0x10
    if (yBits & 0x3 == 0x2) {
      y = -5.0;
    }

    // 0x11 & 0x01
    else if (yBits & 0x3 == 0x1) {
      y = 5.0;
    }

    knobInput.updateKeyboard(playerId, x, y);
  }
}
