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
      game.update();
      _accumulatorTime -= gameSettings.sliceTimeMicroseconds;
    }
  }

  void _draw() {
    final bytes = GameState.bytes(
      game.players,
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
