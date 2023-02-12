import 'dart:async';

import 'package:bubble_fight/di.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Ws<T> implements Disposable {
  late final ReplayConnectableStream<WebSocketChannel> _channel;
  late final ReplayConnectableStream<T> _data;

  late final StreamSubscription _onDataSubscription;
  late final StreamSubscription _channelSubscription;

  Ws(
    String Function(int) uriBuilder,
    T Function(List<int>) instanceBuilder,
  ) {
    _channel = serverClient.channel(uriBuilder).publishReplay(maxSize: 1);
    _data = _channel
        .switchMap((channel) => channel.stream)
        .map((data) => instanceBuilder(data as List<int>))
        .publishReplay(maxSize: 1);

    _channelSubscription = _channel.connect();
    _onDataSubscription = _data.connect();
  }

  Future<void> send(List<int> bytes) async {
    final channel = await _channel.first;
    channel.sink.add(bytes);
  }

  Stream<T> data() => _data.asBroadcastStream();

  @override
  Future<void> onDispose() async {
    await Future.wait([
      _onDataSubscription.cancel(),
      _channelSubscription.cancel(),
    ]);
  }
}
