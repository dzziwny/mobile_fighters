import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

class ServerClient {
  final _playerPositions = <int, BehaviorSubject<Position>>{
    1: BehaviorSubject(),
  };

  final _playerAdded$ = ReplaySubject<List<int>>(maxSize: 1);
  final _playerRemoved$ = ReplaySubject<List<int>>(maxSize: 1);
  // final _guid = const Uuid().v4().hashCode;
  final _guid = 915910247;

  final channel = WebSocketChannel.connect(
    Uri.parse('ws://localhost:8080/ws'),
  );

  run() {
    channel.stream.listen((data) {
      final playerId = data[0];
      final position = Position(
        playerId,
        ByteData.sublistView(Uint8List.fromList(data.sublist(1, 5)))
            .getFloat32(0),
        ByteData.sublistView(Uint8List.fromList(data.sublist(5, 9)))
            .getFloat32(0),
        ByteData.sublistView(Uint8List.fromList(data.sublist(9, 13)))
            .getFloat32(0),
      );

      _playerPositions[playerId]?.add(position);
    });
  }

  void dispose() {
    channel.sink.close(status.goingAway);
  }

  void updateKnob(
    int playerId,
    double angle,
    double deltaX,
    double deltaY,
  ) {
    final angleBytes = (ByteData(4)..setFloat32(0, angle)).buffer.asUint8List();
    final deltaXBytes =
        (ByteData(4)..setFloat32(0, deltaX)).buffer.asUint8List();
    final deltaYBytes =
        (ByteData(4)..setFloat32(0, deltaY)).buffer.asUint8List();

    final frameForServer = <int>[
      playerId,
      ...angleBytes,
      ...deltaXBytes,
      ...deltaYBytes,
    ];

    channel.sink.add(frameForServer);
  }

  Stream<Position> onPlayerPositionUpdate$(int playerId) {
    final position$ = _playerPositions[playerId];
    if (position$ == null) {
      debugger();
      throw "Cannot find position for player id '$playerId'";
    }

    return position$.asBroadcastStream();
  }

  Stream<List<int>> onPlayerRemoved$() {
    return _playerRemoved$.asBroadcastStream();
  }

  Future<int> createPlayer(String nick) async {
    final response = await post(
      Uri.parse('http://localhost:8080/createPlayer'),
      headers: {
        HttpHeaders.contentTypeHeader: ContentType.json.value,
      },
      body: jsonEncode({
        'guid': _guid,
      }),
    );

    final id = int.parse(response.body);

    _playerPositions[id] = BehaviorSubject();
    _playerAdded$.add([id, ...nick.codeUnits]);
    return id;
  }

  Stream<List<int>> onPlayerAdded$() {
    return _playerAdded$.asBroadcastStream();
  }
}

class Position {
  final int playerId;
  final double x;
  final double y;
  final double angle;

  const Position(this.playerId, this.x, this.y, this.angle);
}
