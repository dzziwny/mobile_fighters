import 'dart:async';

import 'package:bubble_fight/attack.dart';
import 'package:bubble_fight/di.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class AttackService implements Disposable {
  final _attacks$ = BehaviorSubject.seeded(<Attack>[]);

  late final _channel =
      serverClient.channel(Endpoint.attackWs).publishReplay(maxSize: 1);

  late final ReplayConnectableStream<void> _onData$ =
      _channel.switchMap((channel) {
    _attacks$.add([]);
    return channel.stream;
  }).map(
    (data) {
      final response = AttackResponse.fromBytes(data as List<int>);
      final attacks = _attacks$.value;
      switch (response.phase) {
        case AttackPhase.start:
          final attack = _toAttack(response);
          attacks.add(attack);
          return _attacks$.add(attacks);
        case AttackPhase.boom:
          final index = attacks.indexWhere((a) => a.serverId == response.id);
          attacks.removeAt(index);
          return _attacks$.add(attacks);
        default:
          assert(false);
      }
    },
  ).publishReplay(maxSize: 1);

  late final StreamSubscription _onDataSubscription;
  late final StreamSubscription _attackChannelSubscription;

  AttackService() {
    _attackChannelSubscription = _channel.connect();
    _onDataSubscription = _onData$.connect();
  }

  Stream<List<Attack>> attacks$() => _attacks$.asBroadcastStream();

  Future<void> attack() async {
    final channel = await _channel.first;
    channel.sink.add(<int>[]);
  }

  Attack _toAttack(AttackResponse response) {
    final startPosition = serverClient.positions[response.attackerId];
    final attack = Attack(
      response.id,
      startPosition?.x ?? 0.0,
      startPosition?.y ?? 0.0,
      response.targetX,
      response.targetY,
    );

    return attack;
  }

  @override
  Future<void> onDispose() async {
    await Future.wait([
      _onDataSubscription.cancel(),
      _attackChannelSubscription.cancel(),
    ]);
  }
}
