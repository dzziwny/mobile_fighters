import 'dart:async';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../inputs/_input.dart';
import '../setup.dart';
import '../updates/_updates.dart';
import 'channels.handler.dart';
import 'on_connection.dart';

class BulletConnection extends OnConnection {
  final gunInput = GetIt.I<BulletInput>();
  final channelsHandler = GetIt.I<ChannelsHandler>();

  bool isShooting = false;
  Timer? timer;
  Future? delay;

  @override
  void onInit(int playerId, WebSocketChannel channel) {
    channelsHandler.addBulletChannel(playerId, channel);
  }

  @override
  void onData(int playerId, Uint8List data) async {
    final isShooting = data[0] == 1;
    if (this.isShooting == isShooting) {
      return;
    }

    this.isShooting = isShooting;
    gunInput.update(playerId, isShooting);
    await delay;
    while (this.isShooting) {
      gameUpdates.add(() => createBulletUpdate(playerId));
      delay = Future.delayed(Duration(milliseconds: 100));
      await delay;
    }
  }
}
