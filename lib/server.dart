import 'dart:io';
import 'dart:typed_data';

import 'package:flame/game.dart';
import 'package:get_it/get_it.dart';

class Server {
  final toServerSocket =
      GetIt.I<RawDatagramSocket>(instanceName: 'toServerSocket');
  final fromServerSenderSocket =
      GetIt.I<RawDatagramSocket>(instanceName: 'fromServerSenderSocket');

  final toHttpServer = GetIt.I<HttpServer>(instanceName: 'toHttpServer');
  final fromHttpServer = GetIt.I<HttpServer>(instanceName: 'fromHttpServer');

  final httpClient = HttpClient();

  final _playerPositions = <int, List<double>>{};
  final _playerKnobs = <int, List<double>>{};
  double maxSpeed = 10.0;
  int ids = 0;

  run() {
    toServerSocket.skip(1).listen((_) {
      final data = toServerSocket.receive()!.data;
      double dt = ByteData.sublistView(Uint8List.fromList(data.sublist(1, 5)))
          .getFloat32(0);
      double deltaX =
          ByteData.sublistView(Uint8List.fromList(data.sublist(5, 9)))
              .getFloat32(0);
      double deltaY =
          ByteData.sublistView(Uint8List.fromList(data.sublist(9, 13)))
              .getFloat32(0);
      final angle = Vector2(deltaX, deltaY).screenAngle();
      final playerId = data[0];
      _playerKnobs[playerId] = [dt, deltaX, deltaY, angle];
      schedulePlayerPositionUpdate(playerId);
    });

    toHttpServer.listen((event) async {
      final id = ++ids;
      _playerPositions[id] = [0.0, 0.0, 0.0];
      _playerKnobs[id] = [0.0, 0.0, 0.0];
      event.response.write(id);
      event.response.close();

      // fromServerSocket.send(
      //   [id, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
      //   fromServerSocket.address,
      //   fromServerSocket.port,
      // );

      // final uri = Uri(
      //   host: fromHttpServer.address.host,
      //   port: fromHttpServer.port,
      // );

      // final response = await http.post(
      //   uri,
      //   body: {
      //     'id': id,
      //   },
      // );
    });
  }

  schedulePlayerPositionUpdate(int playerId) {
    final knob = _playerKnobs[playerId]!;
    final dt = knob[0];
    final deltaX = knob[1];
    final deltaY = knob[2];
    final angle = knob[3];

    final oldPosition = _playerPositions[playerId]!;

    final valuex = deltaX * maxSpeed * dt + oldPosition[0];
    final valuey = deltaY * maxSpeed * dt + oldPosition[1];

    _playerPositions[playerId] = [valuex, valuey, angle];

    final frame = <int>[
      playerId,
      ...(ByteData(4)..setFloat32(0, valuex)).buffer.asUint8List(),
      ...(ByteData(4)..setFloat32(0, valuey)).buffer.asUint8List(),
      ...(ByteData(4)..setFloat32(0, angle)).buffer.asUint8List(),
    ];

    fromServerSenderSocket.send(
      frame,
      InternetAddress('239.10.10.100'),
      4545,
    );
  }
}
