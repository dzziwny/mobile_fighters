import 'dart:async';

import 'package:bubble_fight/di.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class AttackWs implements Disposable {
  late final _channel =
      serverClient.channel(Endpoint.attackWs).publishReplay(maxSize: 1);

  late final _data = _channel
      .switchMap((channel) => channel.stream)
      .map((data) => AttackResponse.fromBytes(data as List<int>))
      .publishReplay(maxSize: 1);

  late final StreamSubscription _onDataSubscription;
  late final StreamSubscription _channelSubscription;

  AttackWs() {
    _channelSubscription = _channel.connect();
    _onDataSubscription = _data.connect();
  }

  Future<void> send(List<int> bytes) async {
    final channel = await _channel.first;
    channel.sink.add(bytes);
  }

  Stream<AttackResponse> data() => _data.asBroadcastStream();

  @override
  Future<void> onDispose() async {
    await Future.wait([
      _onDataSubscription.cancel(),
      _channelSubscription.cancel(),
    ]);
  }
}
