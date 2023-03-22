import 'dart:async';

import 'package:bubble_fight/di.dart';
import 'package:bubble_fight/rxdart.extension.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class HpBloc implements Disposable {
  final _playersHp = BehaviorSubject.seeded(<int, BehaviorSubject<double>>{});

  late final StreamSubscription _playersSubscription;
  late final StreamSubscription _hpSubscription;

  HpBloc() {
    _playersSubscription = playersWs.data().map((map) {
      final players = map.values.toList();
      final hps = _playersHp.value;
      for (var player in players) {
        if (hps.containsKey(player.id)) {
          continue;
        }

        hps[player.id] = BehaviorSubject.seeded(player.hp.toDouble());
      }

      _playersHp.add(hps);
    }).listen(null);

    _hpSubscription = hitWs.data().map((dto) {
      final hps = _playersHp.value;
      final subject = hps[dto.playerId];
      if (subject == null) {
        return;
      }

      final hp = dto.hp.toDouble();
      subject.add(hp);
    }).listen(null);
  }

  ValueStream<double> get(Player player) {
    return _playersHp
        .map((hps) => hps[player.id])
        .skipNull()
        .switchMap((hp$) => hp$)
        .shareValueSeeded(startHpDouble);
  }

  @override
  Future<void> onDispose() async {
    await Future.wait([
      _playersSubscription.cancel(),
      _hpSubscription.cancel(),
    ]);
  }
}
