import 'dart:async';
import 'dart:typed_data';

import 'package:bubble_fight/di.dart';
import 'package:bubble_fight/rxdart.extension.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class PositionBloc implements Disposable {
  final _playersPositions =
      BehaviorSubject.seeded(<int, BehaviorSubject<PlayerPosition>>{});

  late final _playersHandler = playersWs.data().map((players) {
    final subjects = _playersPositions.value;

    // remove players
    for (var id in subjects.keys) {
      if (players[id] != null) {
        continue;
      }

      subjects.remove(id)?.close();
    }

    // add players
    for (var player in players.values) {
      if (subjects.containsKey(player.id)) {
        continue;
      }

      subjects[player.id] = BehaviorSubject.seeded(player.position);
    }

    _playersPositions.add(subjects);
  }).publish();

  late final _positionHandler = gameStateWs.data().map((state) {
    for (var position in state.positions) {
      _playersPositions.value[position.playerId]?.add(position);
    }
  }).publish();

  late final StreamSubscription _playersSubscription;
  late final StreamSubscription _positionsSubscription;

  PositionBloc() {
    _playersSubscription = _playersHandler.connect();
    _positionsSubscription = _positionHandler.connect();
  }

  Stream<List<MapEntry<int, Stream<PlayerPosition>>>> positions() =>
      _playersPositions.map((positions) => positions.entries.toList());

  Stream<PlayerPosition> position(int playerId) {
    return _playersPositions
        .map((positions) {
          return positions[playerId];
        })
        .skipNull()
        .switchMap((stream) => stream);
  }

  Stream<PlayerPosition> myPosition$() =>
      serverClient.id$.switchMap((id) => position(id));

  Future<void> updateKnob(double angle, double deltaX, double deltaY) async {
    final bytes = Uint8List.fromList([
      0,
      ...angle.toBytes(),
      ...deltaX.toBytes(),
      ...deltaY.toBytes(),
    ]);

    await positionsWs.send(bytes);
  }

  Future<void> dash() async {
    final bytes = [1].toBytes();
    await positionsWs.send(bytes);
  }

  @override
  Future onDispose() async {
    await Future.wait([
      _playersSubscription.cancel(),
      _positionsSubscription.cancel(),
    ]);
  }
}
