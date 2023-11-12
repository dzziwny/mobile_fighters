import 'dart:async';

import 'package:bubble_fight/server_client.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Ws<DtoType, DataType> implements Disposable {
  late final ReplayConnectableStream<WebSocketChannel> _channel;
  late final ReplayConnectableStream<DtoType> _data;

  late final StreamSubscription _onDataSubscription;
  late final StreamSubscription _channelSubscription;

  Ws(
    Socket socket,
    DtoType Function(DataType) instanceBuilder,
  ) {
    _channel = serverClient.channel(socket).publishReplay(maxSize: 1);

    _data = _channel
        .switchMap((channel) => channel.stream)
        .map((data) => instanceBuilder(data as DataType))
        .publishReplay(maxSize: 1);

    _channelSubscription = _channel.connect();
    _onDataSubscription = _data.connect();
  }

  Future<void> send(Uint8List bytes) async {
    final channel = await _channel.first;
    channel.sink.add(bytes);
  }

  Stream<DtoType> data() => _data.asBroadcastStream();

  @override
  Future<void> onDispose() async {
    await Future.wait([
      _onDataSubscription.cancel(),
      _channelSubscription.cancel(),
    ]);
  }
}
