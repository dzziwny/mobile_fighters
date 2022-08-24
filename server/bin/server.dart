import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:vector_math/vector_math.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

final _router = Router()
  ..post('/createPlayer', _createPlayerHandler)
  ..get('/ws', webSocketHandler(_webSocketHandler));

final players = <int, int>{
  915910247: 1,
};

final playerPositions = <int, List<double>>{
  1: [0.0, 0.0, 0.0],
};

final playerPositionUpdates = <int, List<int>>{};

final playerKnobs = <int, List<double>>{
  1: [0.0, 0.0, 0.0, 0.0],
};

double maxSpeed = 0.1;
int ids = 0;

Future<Response> _createPlayerHandler(Request request) async {
  final body = jsonDecode(await request.readAsString());
  int guid = body['guid'];
  if (players.keys.contains(guid)) {
    return Response.ok('${players[guid]}');
  }

  final id = ++ids;
  playerPositions[id] = [0.0, 0.0, 0.0];
  playerKnobs[id] = [0.0, 0.0, 0.0];

  players[body['guid']] = id;
  return Response.ok('$id');
}

List<WebSocketChannel> channels = [];

double screenAngle(Vector2 x) =>
    (x.clone()..y *= -1).angleToSigned(Vector2(0.0, 1.0));

void _webSocketHandler(WebSocketChannel channel) {
  channels.add(channel);

  channel.stream.listen((data) {
    double angle = ByteData.sublistView(Uint8List.fromList(data.sublist(1, 5)))
        .getFloat32(0);
    double deltaX = ByteData.sublistView(Uint8List.fromList(data.sublist(5, 9)))
        .getFloat32(0);
    double deltaY =
        ByteData.sublistView(Uint8List.fromList(data.sublist(9, 13)))
            .getFloat32(0);
    final angle = screenAngle(Vector2(deltaX, deltaY));
    final playerId = data[0];
    playerKnobs[playerId] = [dt, deltaX, deltaY, angle];
  });
}

void schedulePlayerPositionUpdate(int playerId, int time) {
  final knob = playerKnobs[playerId];
  if (knob == null) {
    debugger();
    return;
  }

  final deltaX = knob[0];
  final deltaY = knob[1];
  final angle = knob[2];

  final oldPosition = playerPositions[playerId];
  if (oldPosition == null) {
    debugger();
    return;
  }

  final valuex = deltaX * maxSpeed * sliceTime + oldPosition[0];
  final valuey = deltaY * maxSpeed * sliceTime + oldPosition[1];

  playerPositions[playerId] = [valuex, valuey, angle];
  playerPositionUpdates[playerId] = <int>[
    playerId,
    ...(ByteData(4)..setFloat32(0, valuex)).buffer.asUint8List(),
    ...(ByteData(4)..setFloat32(0, valuey)).buffer.asUint8List(),
    ...(ByteData(4)..setFloat32(0, angle)).buffer.asUint8List(),
  ];
}

int lastUpdateTime = DateTime.now().microsecondsSinceEpoch;
int accumulatorTime = 0;
int sliceTime = 100;
double sliceFactor = sliceTime / 200;

void main(List<String> args) async {
  final ip = InternetAddress.anyIPv4;

  final handler = Pipeline()
      // .addMiddleware(
      //   logRequests(),
      // )
      .addHandler(_router);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on port ${server.port}');

  Timer.periodic(Duration.zero, (_) {
    final now = DateTime.now().microsecondsSinceEpoch;
    final dt = now - lastUpdateTime;
    lastUpdateTime += dt;
    accumulatorTime += dt;
    while (accumulatorTime > sliceTime) {
      update(sliceTime);
      accumulatorTime -= sliceTime;
    }
    draw();
  });
}

void update(int time) {
  for (var playerId in players.values) {
    schedulePlayerPositionUpdate(playerId, time);
  }
}

void draw() {
  for (var position in playerPositionUpdates.values) {
    for (var channel in channels) {
      channel.sink.add(position);
    }
  }
}
