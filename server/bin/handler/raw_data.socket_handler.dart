import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';

void rawDataSocketHandlerWeb(WebSocketChannel channel) {
  rawDataWSChannels.add(channel);

  channel.stream.listen((data) {
    if (data is! String) {
      throw Exception('unknown data');
    }

    final intData = data.split(',').map((e) => int.parse(e)).toList();
    return _handler(intData);
  });
}

void rawDataSocketHandler(WebSocketChannel channel) {
  rawDataWSChannels.add(channel);

  channel.stream.listen((data) => _handler(data));
}

void _handler(List<int> data) {
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

void dash(List<int> data) {
  final playerId = data[1];
  if (dashCooldowns[playerId] == true) {
    return;
  }

  gameUpdates.add(() => dashCooldownUpdate(playerId, true));
  playerSpeed[playerId] = dashSpeed;
  dashCooldowns[playerId] = true;

  Timer(Duration(milliseconds: 200), () {
    playerSpeed[playerId] = normalSpeed;
  });

  Timer(Duration(seconds: dashCooldownSesconds), () {
    gameUpdates.add(() => dashCooldownUpdate(playerId, false));
    dashCooldowns[playerId] = false;
  });
}

dashCooldownUpdate(int playerId, bool isCooldown) {
  final channel = cooldownWSChannels[playerId];
  if (channel == null) {
    return;
  }

  final frame = CooldownDto(
    isCooldown: isCooldown,
    cooldownType: CooldownType.dash,
  ).toData();

  channel.sink.add(frame);
}
