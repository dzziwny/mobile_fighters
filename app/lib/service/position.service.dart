import 'dart:async';
import 'dart:typed_data';

import 'package:bubble_fight/di.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class PositionService implements Disposable {
  final _positions$ = BehaviorSubject.seeded(<int, Position>{});

  // TODO use players and make distinguished subject for each player
  late final _handler$ = positionWs.data().map((position) {
    final positions = _positions$.value;
    positions[position.playerId] = position;
    _positions$.add(positions);
  }).publishReplay(maxSize: 1);

  late final _myPosition$ = serverClient.id$
      .switchMap(
        (id) => positionWs.data().where((position) => position.playerId == id),
      )
      .publishReplay(maxSize: 1);

  late final StreamSubscription _positionSubscription;
  late final StreamSubscription _myPositionSubscription;

  PositionService() {
    _positionSubscription = _handler$.connect();
    _myPositionSubscription = _myPosition$.connect();
  }

  Stream<Map<int, Position>> positions$() => _positions$.asBroadcastStream();
  Stream<Position> myPosition$() => _myPosition$.asBroadcastStream();

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
  Future<void> onDispose() async {
    await Future.wait([
      _positionSubscription.cancel(),
      _myPositionSubscription.cancel(),
    ]);
  }
}
