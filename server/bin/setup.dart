import 'dart:convert';

import 'package:core/core.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

/*
* key   ->  guid
* value ->  id
*/
final guids = <int, int>{};
/*
* key   ->  id
* value ->  Player
*/
final players = <int, Player>{};

/*
* key   ->  playerId
* value ->  [x, y, angle]
*/
final playerPositions = <int, List<double>>{};

final playerSpeed = <int, double>{};

final playerPositionUpdates = <int, List<int>>{};

final playerKnobs = <int, List<double>>{};

int ids = 0;

List<WebSocketChannel> rawDataWSChannels = [];
List<WebSocketChannel> playersWSChannels = [];
List<WebSocketChannel> playerChangeWSChannels = [];

double normalSpeed = 0.00001;
double dashSpeed = 0.00005;
double maxX = 750;
double minX = 50;
double maxY = 550;
double minY = 50;

void sharePlayers() {
  for (final channel in playersWSChannels) {
    final data = jsonEncode(players.values.toList());
    channel.sink.add(data);
  }
}

void sharePlayerCreated(int id) {
  final player = players[id];
  if (player == null) {
    return;
  }

  final dto = PlayerChangeDto(
    id: id,
    nick: player.nick,
    type: PlayerChangeType.added,
  );

  final data = jsonEncode(dto);
  for (final channel in playerChangeWSChannels) {
    channel.sink.add(data);
  }
}

void sharePlayerRemoved(int id) {
  final dto = PlayerChangeDto(
    id: id,
    nick: '',
    type: PlayerChangeType.removed,
  );

  final data = jsonEncode(dto);
  for (final channel in playerChangeWSChannels) {
    channel.sink.add(data);
  }
}
