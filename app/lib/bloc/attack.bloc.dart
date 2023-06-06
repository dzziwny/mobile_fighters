import 'dart:async';

import 'package:bubble_fight/attack.dart';
import 'package:bubble_fight/di.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class AttackBloc implements Disposable {
  final _attacks$ = BehaviorSubject.seeded(<Attack>[]);

  late final _handler = gameStateWs.data().map(
    (state) {
      for (var bomb in state.bombs) {
        final attacks = _attacks$.value;
        switch (bomb.phase) {
          case AttackPhase.start:
            final attack = Attack(
              bomb.id,
              bomb.sourceX,
              bomb.sourceY,
              bomb.targetX,
              bomb.targetY,
            );
            attacks.add(attack);
            return _attacks$.add(attacks);
          case AttackPhase.boom:
            final index = attacks.indexWhere((a) => a.serverId == bomb.id);
            attacks.removeAt(index);
            return _attacks$.add(attacks);
          default:
            assert(false);
        }
      }
    },
  ).publishReplay(maxSize: 1);

  late final StreamSubscription _handlerSubscription;

  AttackBloc() {
    _handlerSubscription = _handler.connect();
  }

  Stream<List<Attack>> attacks$() => _attacks$.asBroadcastStream();

  Future<void> attack() => bombsWs.send(AttackRequest.bomb);

  @override
  Future onDispose() async {
    await _handlerSubscription.cancel();
  }
}
