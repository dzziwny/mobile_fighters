import 'dart:convert';

import 'package:core/core.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'model/player_physics.dart';

/*
* key   ->  guid
* value ->  id
*/
final guids = <String, int>{};
/*
* key   ->  id
* value ->  Player
*/
final players = <int, Player>{};

/*
* physics
* key   ->  playerId
* value ->  [x, y, angle]
*/
final playerPhysics = <int, PlayerPhysics>{};

/*
* cooldowns
* key   ->  playerId
* value ->  [x, y, angle]
*/

final Map<int, bool> pushCooldowns = {};
final Map<int, bool> dashCooldowns = {};
final Map<int, bool> attackCooldowns = {};

/*
* key   ->  playerId
* value ->  hp max 100, min 0
*/
final playerHp = <int, int>{};

/*
* Game events. First value indicates, what event came.
* 0 - position update
* 1 - attack
*/
final gameUpdates = <void Function()>[];

/*
* Game draws. First value indicates, what event came.
* 0 - position update
* 1 - attack
*/
final gameDraws = <void Function()>[];

/*
* Teams
*/

Map<int, Player> redTeam = {};
Map<int, Player> blueTeam = {};

Map<Team, Map<int, Player>> teams = {
  Team.red: redTeam,
  Team.blue: blueTeam,
};

int ids = 0;

GamePhase phase = GamePhase.selectingTeam;

Player? gameHost;

List<WebSocketChannel> pushChannels = [];
List<WebSocketChannel> playersWSChannels = [];
List<WebSocketChannel> playerChangeWSChannels = [];
List<WebSocketChannel> attackWSChannels = [];
List<WebSocketChannel> hitWSChannels = [];
Map<int, WebSocketChannel> cooldownWSChannels = {};
Map<int, WebSocketChannel> deadWSChannels = {};
Map<int, WebSocketChannel> teamsWSChannels = {};
Map<int, WebSocketChannel> gamePhaseWSChannels = {};
Map<int, WebSocketChannel> dashChannels = {};

// If there are lags, try make sliceTime smaller
const int sliceTimeMicroseconds = 5000;
const double sliceTimeSeconds = sliceTimeMicroseconds / 1000000.0;

const double normalSpeed = 0.00001;
const double dashSpeed = 0.00005;

// Ultra HD xddddd
const double frameWidth = 2160.0;
const double frameHeight = 1620.0;
const int pushCooldownMilisesconds = 20;

TeamsDto prepareTeams() => TeamsDto(
      red: redTeam.values.map((e) => e.nick).toList(),
      blue: blueTeam.values.map((e) => e.nick).toList(),
    );

void shareTeams() {
  final dto = prepareTeams();
  final data = jsonEncode(dto);
  for (var teamChannel in teamsWSChannels.values) {
    teamChannel.sink.add(data);
  }
}

void sharePlayers() {
  for (final channel in playersWSChannels) {
    final data = jsonEncode(players.values.toList());
    channel.sink.add(data);
  }
}

void sharePlayerRemoved(Player player) {
  final dto = PlayerChangeDto(
    id: player.id,
    nick: '',
    type: PlayerChangeType.removed,
    team: player.team,
  );

  final data = jsonEncode(dto);
  for (final channel in playerChangeWSChannels) {
    channel.sink.add(data);
  }
}

void removePlayer(int id) {
  playerPhysics.remove(id);
  redTeam.remove(id);
  blueTeam.remove(id);
  final player = players.remove(id);

  sharePlayers();
  shareTeams();
  if (player != null) {
    sharePlayerRemoved(player);
  }
}
