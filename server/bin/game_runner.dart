import 'dart:async';

import 'package:core/core.dart';

import 'ammunition/ammunition.physic.dart';
import 'ammunition/bomb_loop.dart';
import 'ammunition/bullet_loop.dart';
import 'ammunition/dash_loop.dart';
import 'register_di.dart';
import 'game_setup.dart';
import 'updates/_updates.dart';

class GameRunner {
  Timer? _gameCycleTimer;
  Timer? _drawTimer;

  int _lastUpdateTime = DateTime.now().microsecondsSinceEpoch;
  int _accumulatorTime = 0;

  void tryStartGame() {
    if (_gameCycleTimer?.isActive == true) {
      return;
    }

    _lastUpdateTime = DateTime.now().microsecondsSinceEpoch;
    restartGameCycleTimer();
    restartDrawTimer();
    print('Game is started');
  }

  void restartGameCycleTimer() {
    _gameCycleTimer?.cancel();
    var frameRate = Duration(milliseconds: gameSettings.frameRate);
    _gameCycleTimer = Timer.periodic(frameRate, (_) => _gameCycle());
  }

  void stopGame() {
    _gameCycleTimer?.cancel();
    _drawTimer?.cancel();
    print('Game is stopped');
  }

  // used when user changes settings manually
  void restartDrawTimer() {
    _drawTimer?.cancel();
    var rate = Duration(microseconds: gameSettings.gameDrawRate);
    _drawTimer = Timer.periodic(rate, (_) => _draw());
  }

  void _gameCycle() {
    final now = DateTime.now().microsecondsSinceEpoch;
    final dt = now - _lastUpdateTime;
    _lastUpdateTime = now;
    _accumulatorTime += dt;
    while (_accumulatorTime > gameSettings.sliceTimeMicroseconds) {
      _update();
      _accumulatorTime -= gameSettings.sliceTimeMicroseconds;
    }
  }

  void _update() {
    _executeActions();
    _physicUpdate();
  }

  void _executeActions() {
    for (var i = 0; i < gameSettings.maxPlayers; i++) {
      bulletsLoop.toggle(i, playerInputs[i].isBullet);
      bombsLoop.toggle(i, playerInputs[i].isBomb);
      dashLoop.toggle(i, playerInputs[i].isDash);
    }
  }

  void _physicUpdate() {
    for (var i = 0; i < gameSettings.maxBullets; i++) {
      ammunitionPhysicUpdate(
        ammo: bullets[i],
        dt: gameSettings.sliceTimeSeconds,
        maxDistance: gameSettings.bulletDistanceSquared,
        hitDistance: gameSettings.bulletPlayerCollisionDistanceSquare,
        power: gameSettings.bulletPower,
      );
    }

    for (var i = 0; i < gameSettings.maxBombs; i++) {
      ammunitionPhysicUpdate(
        ammo: bombs[i],
        dt: gameSettings.sliceTimeSeconds,
        maxDistance: gameSettings.bombDistanceSquared,
        hitDistance: gameSettings.bombPlayerCollisionDistanceSquare,
        power: gameSettings.bombPower,
      );
    }

    for (var i = 0; i < gameSettings.maxPlayers; i++) {
      playerPhysicUpdate(playerInputs[i]);
    }
  }

  void _draw() {
    final bytes = GameState.bytes(
      players,
      bombs,
      hits,
      bullets,
      frags,
    );

    hits.fillRange(0, gameSettings.maxPlayers.bitLength, 0);

    for (var channel in gameStateChannels) {
      channel.sink.add(bytes);
    }
  }
}
