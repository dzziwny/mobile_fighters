import 'dart:async';

import 'package:bubble_fight/di.dart';
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

  final _frags = <FragRowModel>{};

  late final _handler = gameStateWs.data().map((state) {
    // TODO
    // final players = playersService.players;
    // for (var dto in state.frags) {
    //   final killer = players[dto.killerId];
    //   if (killer == null) {
    //     continue;
    //   }

    //   final enemy = players[dto.enemyId];
    //   if (enemy == null) {
    //     continue;
    //   }

    //   final frag = FragRowModel(
    //     killer: killer.nick,
    //     killerTeam: killer.team,
    //     enemy: enemy.nick,
    //     enemyTeam: enemy.team,
    //   );

    //   _frags.add(frag);
    //   Timer.periodic(
    //     const Duration(seconds: 3),
    //     (timer) {
    //       timer.cancel();
    //       _frags.remove(frag);
    //       frags.add(_frags);
    //     },
    //   );
    // }

    // frags.add(_frags);
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
