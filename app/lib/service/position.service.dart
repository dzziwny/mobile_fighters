import 'dart:async';

import 'package:bubble_fight/di.dart';
import 'package:core/core.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

// TODO create abstraction around a service for channel handling and data parse
class PositionService implements Disposable {
  final _positions = <int, Position>{};

  final _position$ = ReplaySubject<Position>(maxSize: 1);

  late final _channel = serverClient
      .channel(kIsWeb ? Endpoint.pushWsWeb : Endpoint.pushWs)
      .publishReplay(maxSize: 1);

  late final _onData$ =
      _channel.switchMap((channel) => channel.stream).map((data) {
    final position = Position.fromBytes(data);
    _position$.add(position);
  }).publishReplay(maxSize: 1);

  late final _positions$ = _position$.map((position) {
    _positions[position.playerId] = position;
    return _positions;
  }).publishReplay(maxSize: 1);

  late final _myPosition$ = serverClient.id$
      .switchMap(
          (id) => _position$.where((position) => position.playerId == id))
      .publishReplay(maxSize: 1);

  late final StreamSubscription _onDataSubscription;
  late final StreamSubscription _channelSubscription;
  late final StreamSubscription _positionSubscription;
  late final StreamSubscription _myPositionSubscription;

  PositionService() {
    _channelSubscription = _channel.connect();
    _onDataSubscription = _onData$.connect();
    _positionSubscription = _positions$.connect();
    _myPositionSubscription = _myPosition$.connect();
  }

  Stream<Map<int, Position>> positions$() => _positions$.asBroadcastStream();
  Stream<Position> myPosition$() => _myPosition$.asBroadcastStream();

  Future<void> updatePosition(
    double angle,
    double deltaX,
    double deltaY,
  ) async {
    final angleBytes = (ByteData(4)..setFloat32(0, angle)).buffer.asUint8List();
    final deltaXBytes =
        (ByteData(4)..setFloat32(0, deltaX)).buffer.asUint8List();
    final deltaYBytes =
        (ByteData(4)..setFloat32(0, deltaY)).buffer.asUint8List();

    final frame = <int>[
      0,
      ...angleBytes,
      ...deltaXBytes,
      ...deltaYBytes,
    ];

    final channel = await _channel.first;
    channel.sink.add(frame);
  }

  Future<void> dash() async {
    final data = <int>[1];
    final channel = await _channel.first;
    channel.sink.add(data);
  }

  @override
  Future onDispose() async {
    await Future.wait([
      _onDataSubscription.cancel(),
      _channelSubscription.cancel(),
      _positionSubscription.cancel(),
      _myPositionSubscription.cancel(),
    ]);
  }
}
