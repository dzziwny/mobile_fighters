import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class ServerClient {
  final _playerPositions = <int, BehaviorSubject<Position>>{};
  final _playerAdded$ = ReplaySubject<List<int>>(maxSize: 1);
  final _playerRemoved$ = ReplaySubject<List<int>>(maxSize: 1);

  final toServerSocket =
      GetIt.I<RawDatagramSocket>(instanceName: 'toServerSocket');
  final fromServerSocket =
      GetIt.I<RawDatagramSocket>(instanceName: 'fromServerSocket');
  final toHttpServer = GetIt.I<HttpServer>(instanceName: 'toHttpServer');
  final httpClient = HttpClient();

  run() {
    fromServerSocket.skip(1).listen((data) {
      final data = fromServerSocket.receive()!.data;
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

      _playerPositions[playerId]!.add(position);
    });
  }

  void updateKnob(
    int playerId,
    double dt,
    double deltaX,
    double deltaY,
  ) {
    final dtBytes = (ByteData(4)..setFloat32(0, dt)).buffer.asUint8List();
    final deltaXBytes =
        (ByteData(4)..setFloat32(0, deltaX)).buffer.asUint8List();
    final deltaYBytes =
        (ByteData(4)..setFloat32(0, deltaY)).buffer.asUint8List();

    final frameForServer = <int>[
      playerId,
      ...dtBytes,
      ...deltaXBytes,
      ...deltaYBytes,
    ];

    toServerSocket.send(
      frameForServer,
      toServerSocket.address,
      toServerSocket.port,
    );
  }

  Stream<Position> onPlayerPositionUpdate$(int playerId) {
    return _playerPositions[playerId]!.asBroadcastStream();
  }

  Stream<List<int>> onPlayerRemoved$() {
    return _playerRemoved$.asBroadcastStream();
  }

  Future<int> createPlayer(String nick) async {
    final request = await httpClient.post(
      toHttpServer.address.host,
      toHttpServer.port,
      'createPlayer',
    );

    request.headers.set(
      HttpHeaders.contentTypeHeader,
      "plain/text",
    );
    request.write(nick);

    final response = await request.close();
    final stringData = await response.transform(utf8.decoder).join();

    final id = int.parse(stringData);

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
