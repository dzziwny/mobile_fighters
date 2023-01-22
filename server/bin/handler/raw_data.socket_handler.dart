import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:vector_math/vector_math.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';

void movementSocketHandlerWeb(WebSocketChannel channel) {
  rawDataWSChannels.add(channel);

  channel.stream.listen((data) {
    if (data is! String) {
      throw Exception('unknown data');
    }

    final intData = data.split(',').map((e) => int.parse(e)).toList();
    return _handler(intData);
  });
}

void movementSocketHandler(WebSocketChannel channel) {
  rawDataWSChannels.add(channel);

  channel.stream.listen((data) => _handler(data));
}

void _handler(List<int> data) {
  switch (data[0]) {
    case 0:
      push(data);
      break;
    case 1:
      dash(data);
      break;
    default:
      assert(false);
  }
}

// TODO change file name
void push(List<int> data) {
  final playerId = data[1];
  if (pushCooldowns[playerId] == true) {
    return;
  }
  pushCooldowns[playerId] = true;

  double angle = ByteData.sublistView(Uint8List.fromList(data.sublist(2, 6)))
      .getFloat32(0);
  if (angle > pi || angle < -pi) {
    return;
  }

  double dx = ByteData.sublistView(Uint8List.fromList(data.sublist(6, 10)))
      .getFloat32(0);
  if (dx > 1.0 || dx < -1.0) {
    return;
  }

  double dy = ByteData.sublistView(Uint8List.fromList(data.sublist(10, 14)))
      .getFloat32(0);
  if (dy > 1.0 || dy < -1.0) {
    return;
  }

  //TODO: simply calculation here and calculation on player joystic
  playerPhysics[playerId]?.pushingForce = Vector2(dx, dy) * 5.0;
  playerPhysics[playerId]?.angle = angle;

  Timer(Duration(milliseconds: pushCooldownMilisesconds), () {
    pushCooldowns[playerId] = false;
  });
}

void dash(List<int> data) {
  final playerId = data[1];
  if (dashCooldowns[playerId] == true) {
    return;
  }

  // TODO
  // playerPhysics[playerId]?.pushingForce = Vecto;
  gameUpdates.add(() => dashCooldownUpdate(playerId, true));
  dashCooldowns[playerId] = true;

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
