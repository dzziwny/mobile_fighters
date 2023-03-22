import 'dart:async';

import 'package:bubble_fight/di.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class FragBloc implements Disposable {
  final frags = BehaviorSubject.seeded(<FragDto>{});

  final _frags = <FragDto>{};

  late final _handler = fragWs.data().map((dto) {
    _frags.add(dto);
    frags.add(_frags);

    Timer.periodic(
      const Duration(seconds: 3),
      (timer) {
        timer.cancel();
        _frags.remove(dto);
        frags.add(_frags);
      },
    );
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
