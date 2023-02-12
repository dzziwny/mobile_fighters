import 'dart:async';

import 'package:bubble_fight/di.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class PositionWs implements Disposable {
  late final _channel = serverClient
      .channel(kIsWeb ? Endpoint.pushWsWeb : Endpoint.pushWs)
      .publishReplay(maxSize: 1);

  late final _data = _channel
      .switchMap((channel) => channel.stream)
      .map((data) => Position.fromBytes(data))
      .publishReplay(maxSize: 1);

  late final StreamSubscription _onDataSubscription;
  late final StreamSubscription _channelSubscription;

  PositionWs() {
    _channelSubscription = _channel.connect();
    _onDataSubscription = _data.connect();
  }

  Stream<Position> data() => _data.asBroadcastStream();

  Future<void> send(List<int> bytes) async {
    final channel = await _channel.first;
    channel.sink.add(bytes);
  }

  @override
  Future onDispose() async {
    await Future.wait([
      _onDataSubscription.cancel(),
      _channelSubscription.cancel(),
    ]);
  }
}
