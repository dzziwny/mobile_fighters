import 'dart:async';

import 'package:core/core.dart';
import 'package:get_it/get_it.dart';

import 'game.dart';
import 'register_di.dart';

class GameRunner {
  final game = GetIt.I<Game>();

  Timer? _gameCycleTimer;
  Timer? _drawTimer;

  int _lastUpdateTime = DateTime.now().microsecondsSinceEpoch;
  int _accumulatorTime = 0;

  void tryStartGame() {
    if (_gameCycleTimer?.isActive == true) {
      return;
    }

    _lastUpdateTime = DateTime.now().microsecondsSinceEpoch;
    restartGameCycle();
    print('Game is started');
  }

  void stopGame() {
    _gameCycleTimer?.cancel();
    _drawTimer?.cancel();
    print('Game is stopped');
  }

  // used when user changes settings manually
  void restartGameCycle() {
    _gameCycleTimer?.cancel();
    _gameCycleTimer = Timer.periodic(
      Duration(milliseconds: gameSettings.frameRate),
      (_) => _gameCycle(),
    );

    _drawTimer?.cancel();
    _drawTimer = Timer.periodic(
      Duration(microseconds: gameSettings.gameDrawRate),
      (_) => _draw(),
    );
  }

  void _gameCycle() {
    final now = DateTime.now().microsecondsSinceEpoch;
    final dt = now - _lastUpdateTime;
    _lastUpdateTime = now;
    _accumulatorTime += dt;
    while (_accumulatorTime > gameSettings.sliceTimeMicroseconds) {
      game.update();
      _accumulatorTime -= gameSettings.sliceTimeMicroseconds;
    }
  }

  void _draw() {
    final bytes = GameState.bytes(
      game.players,
      game.bombs,
      game.hits,
      game.bullets,
      game.frags,
    );

    game.hits.fillRange(0, gameSettings.maxPlayers.bitLength, 0);

    for (var channel in gameStateChannels) {
      channel.sink.add(bytes);
    }
  }
}
