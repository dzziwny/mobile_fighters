import 'dart:async';
import 'dart:math';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:vector_math/vector_math.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';

void pushSocketHandlerWeb(WebSocketChannel channel, int playerId) {
  rawDataWSChannels.add(channel);

  channel.stream.listen((data) {
    if (data is! String) {
      throw Exception('unknown data');
    }

    final intData = data.split(',').map((e) => int.parse(e)).toList();
    return _handler(intData, playerId);
  });
}

void pushSocketHandler(WebSocketChannel channel, int playerId) {
  rawDataWSChannels.add(channel);

  channel.stream.listen((data) => _handler(data, playerId));
}

void _handler(List<int> data, int playerId) {
  switch (data[0]) {
    case 0:
      push(data, playerId);
      break;
    case 1:
      dash(data, playerId);
      break;
    default:
      assert(false);
  }
}

void push(List<int> data, int playerId) {
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

void dash(List<int> data, int playerId) {
  if (dashCooldowns[playerId] == true) {
    return;
  }

  final physic = playerPhysics[playerId];
  if (physic == null) {
    return;
  }

  final update = physic.velocity.normalized() * 50.0;
  physic.velocity.add(update);

  gameUpdates.add(() => dashCooldownUpdate(playerId, true));
  dashCooldowns[playerId] = true;

  Timer(Duration(seconds: dashCooldownSesconds), () {
    gameUpdates.add(() => dashCooldownUpdate(playerId, false));
    dashCooldowns[playerId] = false;
  });
}

void dashCooldownUpdate(int playerId, bool isCooldown) {
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
