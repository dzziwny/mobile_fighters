import 'dart:io';
import 'dart:typed_data';

import 'package:bubble_fight/statics.dart' as statics;
import 'package:vector_math/vector_math.dart';

Future<void> main() async {
  final toServerSocket = await RawDatagramSocket.bind(
    InternetAddress.anyIPv4,
    statics.toServerSocketPort,
  );

  print(
    '[SOCKET] receiving at: ${toServerSocket.address.host}:${toServerSocket.port}',
  );

  final fromServerSenderSocket =
      await RawDatagramSocket.bind(InternetAddress.anyIPv4, 0);

  print(
    '[SOCKET] sending from: ${fromServerSenderSocket.address.host}:${fromServerSenderSocket.port}',
  );
  print(
    '[SOCKET] sending multicast to: ${statics.multicastAddress.host}:${statics.multicastPort}',
  );

  final toHttpServer = await HttpServer.bind(
    statics.toHttpServerAddress,
    statics.toHttpServerPort,
  );
  print(
    '[HTTPS] receiving at: ${statics.toHttpServerAddress.host}:${statics.toHttpServerPort}',
  );

  final playerPositions = <int, List<double>>{};
  final playerKnobs = <int, List<double>>{};
  double maxSpeed = 10.0;
  int ids = 0;

  schedulePlayerPositionUpdate(int playerId) {
    final knob = playerKnobs[playerId]!;
    final dt = knob[0];
    final deltaX = knob[1];
    final deltaY = knob[2];
    final angle = knob[3];

    final oldPosition = playerPositions[playerId]!;

    final valuex = deltaX * maxSpeed * dt + oldPosition[0];
    final valuey = deltaY * maxSpeed * dt + oldPosition[1];

    playerPositions[playerId] = [valuex, valuey, angle];

    final frame = <int>[
      playerId,
      ...(ByteData(4)..setFloat32(0, valuex)).buffer.asUint8List(),
      ...(ByteData(4)..setFloat32(0, valuey)).buffer.asUint8List(),
      ...(ByteData(4)..setFloat32(0, angle)).buffer.asUint8List(),
    ];

    fromServerSenderSocket.send(
      frame,
      statics.multicastAddress,
      statics.multicastPort,
    );
  }

  double screenAngle(Vector2 x) =>
      (x.clone()..y *= -1).angleToSigned(Vector2(0.0, 1.0));

  run() {
    toServerSocket.skip(1).listen((_) {
      final data = toServerSocket.receive()?.data;
      print('[RECEIVED UDP DATA]: $data');
      if (data == null) {
        return;
      }
      double dt = ByteData.sublistView(Uint8List.fromList(data.sublist(1, 5)))
          .getFloat32(0);
      double deltaX =
          ByteData.sublistView(Uint8List.fromList(data.sublist(5, 9)))
              .getFloat32(0);
      double deltaY =
          ByteData.sublistView(Uint8List.fromList(data.sublist(9, 13)))
              .getFloat32(0);
      final angle = screenAngle(Vector2(deltaX, deltaY));
      final playerId = data[0];
      playerKnobs[playerId] = [dt, deltaX, deltaY, angle];
      schedulePlayerPositionUpdate(playerId);
    });

    toHttpServer.listen((event) async {
      print('[RECEIVED HTTP DATA]: $event');
      final id = ++ids;
      playerPositions[id] = [0.0, 0.0, 0.0];
      playerKnobs[id] = [0.0, 0.0, 0.0];
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

  run();
}
