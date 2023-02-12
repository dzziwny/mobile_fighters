import 'dart:async';

import 'package:bubble_fight/attack.dart';
import 'package:bubble_fight/di.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class AttackBloc implements Disposable {
  final _attacks$ = BehaviorSubject.seeded(<Attack>[]);

  late final _handler = attackService.data().withLatestFrom(
    positionService.positions$(),
    (AttackResponse response, Map<int, Position> positions) {
      final attacks = _attacks$.value;
      switch (response.phase) {
        case AttackPhase.start:
          final startPosition = positions[response.attackerId];
          final attack = Attack(
            response.id,
            startPosition?.x ?? 0.0,
            startPosition?.y ?? 0.0,
            response.targetX,
            response.targetY,
          );
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

  late final StreamSubscription _handlerSubscription;

  AttackBloc() {
    _handlerSubscription = _handler.connect();
  }

  Stream<List<Attack>> attacks$() => _attacks$.asBroadcastStream();

  @override
  Future onDispose() async {
    await _handlerSubscription.cancel();
  }
}
