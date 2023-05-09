import 'dart:async';

import 'package:bubble_fight/di.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class BulletBloc implements Disposable {
  final bullets = ValueNotifier(<int, BulletResponse>{});

  late final StreamSubscription _subscription;

  BulletBloc() {
    _subscription = bulletWs.data().map((bullet) {
      if (bullet.isRemoved) {
        bullets.value.remove(bullet.id);
      } else {
        bullets.value[bullet.id] = bullet;
      }
      bullets.value[bullet.id] = bullet;

      bullets.notifyListeners();
    }).listen(null);
  }

  @override
  Future<void> onDispose() async {
    await _subscription.cancel();
  }
}
