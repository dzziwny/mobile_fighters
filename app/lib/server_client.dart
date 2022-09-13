import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:uuid/uuid.dart';
import 'package:web_socket_channel/status.dart' as status;
import 'package:web_socket_channel/web_socket_channel.dart';

class ServerClient implements Disposable {
  final _guid = const Uuid().v4().hashCode;

  late final WebSocketChannel positionsChannel;
  late final WebSocketChannel playersChannel;
  late final WebSocketChannel playersChangeChannel;

  final id$ = BehaviorSubject<int?>.seeded(null);

  ServerClient() {
    positionsChannel = WebSocketChannel.connect(
      Uri.parse('ws://$host:$port${Endpoint.positionWs}'),
    );
    playersChannel = WebSocketChannel.connect(
      Uri.parse('ws://$host:$port${Endpoint.playersWs}'),
    );
    playersChangeChannel = WebSocketChannel.connect(
      Uri.parse('ws://$host:$port${Endpoint.playerChangeWs}'),
    );
  }

  Stream<Position> position$() {
    return positionsChannel.stream.map((data) => _dataToPosition(data));
  }

  Stream<PlayerChangeDto> playerChange$() {
    return playersChangeChannel.stream.map((data) => _dataToPlayerChange(data));
  }

  Stream<List<Player>> players$() {
    return playersChannel.stream.map((data) => _dataToPlayers(data));
  }

  List<Player> _dataToPlayers(String data) {
    final json = jsonDecode(data);
    final List list = json;
    final players = list.map((e) => Player.fromJson(e)).toList();
    return players;
  }

  Position _dataToPosition(List<int> data) {
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

    return position;
  }

  PlayerChangeDto _dataToPlayerChange(String data) {
    final json = jsonDecode(data);
    final dto = PlayerChangeDto.fromJson(json);
    return dto;
  }

  void updateKnob(
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
      // TODO: user can't just update position for someone else
      id$.value!,
      ...angleBytes,
      ...deltaXBytes,
      ...deltaYBytes,
    ];

    positionsChannel.sink.add(frameForServer);
  }

  Future<int> createPlayer(String nick) async {
    final dto = await createPlayer$(_guid, nick);

    final id = dto.id;

    id$.add(id);
    return id;
  }

  Future<void> leaveGame() => leaveGame$(_guid).then((_) => id$.add(null));

  Stream<bool> isInGame() => id$.map((id) => id != null);

  @override
  FutureOr onDispose() {
    positionsChannel.sink.close(status.goingAway);
    playersChannel.sink.close(status.goingAway);
    playersChangeChannel.sink.close(status.goingAway);
  }
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
