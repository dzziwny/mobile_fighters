import 'dart:async';

import 'package:bubble_fight/game_state/game_state_ws.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class FragRowModel {
  final String killer;
  final Team killerTeam;
  final String enemy;
  final Team enemyTeam;

  FragRowModel({
    required this.killer,
    required this.killerTeam,
    required this.enemy,
    required this.enemyTeam,
  });
}

class FragBloc implements Disposable {
  final frags = BehaviorSubject.seeded(<FragRowModel>{});

  late final _handler = gameStateWs.data().map((state) {
    // TODO
  });

  late final StreamSubscription _handlerSubscription;

  FragBloc() {
    _handlerSubscription = _handler.listen(null);
  }

  @override
  Future onDispose() async {
    await _handlerSubscription.cancel();
  }
}

final fragBloc = FragBloc();
