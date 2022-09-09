import 'dart:developer';
import 'dart:typed_data';

import 'package:core/core.dart';
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
  final _guid = const Uuid().v4().hashCode;

  late final WebSocketChannel channel;

  ServerClient() {
    channel = WebSocketChannel.connect(
      Uri.parse('ws://$host:$port${Endpoint.webSocket}'),
    );
  }

  run() {
    channel.stream.listen((data) => onServerData(data));
  }

  void onServerData(List<int> data) {
    final operation = data[0];
    switch (operation) {
      case 1:
        // TODO: can be more performant - dont move sublist, just fix logic in updatePlayerPosition
        _updatePlayerPosition(data.sublist(1));
        break;
      case 2:
        // TODO: can be more performant - dont move sublist, just fix logic in updatePlayerPosition
        _playerAdded$.add(data.sublist(1));
        break;
      case 3:
        // TODO: can be more performant - dont move sublist, just fix logic in updatePlayerPosition
        _removePlayer(data.sublist(1));
        break;
      default:
    }
  }

  void _removePlayer(List<int> data) {
    final playerId = data[0];
    _playerPositions.remove(playerId);
    _playerRemoved$.add(data);
  }

  void _updatePlayerPosition(List<int> data) {
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
    final dto = await createPlayer$(_guid);

    final id = dto.id;

    _playerPositions[id] = BehaviorSubject();
    _playerAdded$.add([id, ...nick.codeUnits]);
    return id;
  }

  Stream<List<int>> onPlayerAdded$() {
    return _playerAdded$.asBroadcastStream();
  }

  Future<void> leaveGame() => leaveGame$(_guid);
}

class Position {
  final int playerId;
  final double x;
  final double y;
  final double angle;

  const Position(this.playerId, this.x, this.y, this.angle);

  @override
  String toString() {
    return "position: [id: $playerId, x: $x, y: $y, angle: $angle]";
  }
}
