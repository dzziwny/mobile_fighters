import 'dart:async';
import 'dart:typed_data';

import 'package:bubble_fight/di.dart';
import 'package:bubble_fight/rxdart.extension.dart';
import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class PositionBloc implements Disposable {
  final _playersPositions =
      BehaviorSubject.seeded(<int, BehaviorSubject<Position>>{});

  late final _playersHandler = playersWs.data().map((players) {
    final subjects = _playersPositions.value;
    for (var player in players.values) {
      if (subjects.containsKey(player.id)) {
        return;
      }

      subjects[player.id] = BehaviorSubject.seeded(player.position);
      _playersPositions.add(subjects);

      // TODO remove also
    }
  }).publish();

  late final _positionHandler = positionWs.data().map((position) {
    _playersPositions.value[position.playerId]?.add(position);
  }).publish();

  late final StreamSubscription _playersSubscription;
  late final StreamSubscription _positionsSubscription;

  PositionBloc() {
    _playersSubscription = _playersHandler.connect();
    _positionsSubscription = _positionHandler.connect();
  }

  Stream<List<MapEntry<int, Stream<Position>>>> positions() =>
      _playersPositions.map((positions) => positions.entries.toList());

  Stream<Position> position(int playerId) {
    return _playersPositions
        .map((positions) => positions[playerId])
        .skipNull()
        .switchMap((stream) => stream);
  }

  Stream<Position> myPosition$() =>
      serverClient.id$.switchMap((id) => position(id));

  // TODO check if there is a quicker solution
  Future<void> updateKnob(double angle, double deltaX, double deltaY) async {
    final angleBytes = (ByteData(4)..setFloat32(0, angle)).buffer.asUint8List();
    final deltaXBytes =
        (ByteData(4)..setFloat32(0, deltaX)).buffer.asUint8List();
    final deltaYBytes =
        (ByteData(4)..setFloat32(0, deltaY)).buffer.asUint8List();

    final bytes = <int>[
      0,
      ...angleBytes,
      ...deltaXBytes,
      ...deltaYBytes,
    ];

    await positionWs.send(bytes);
  }

  Future<void> dash() async {
    final bytes = <int>[1];
    await positionWs.send(bytes);
  }

  @override
  Future onDispose() async {
    await Future.wait([
      _playersSubscription.cancel(),
      _positionsSubscription.cancel(),
    ]);
  }
}
