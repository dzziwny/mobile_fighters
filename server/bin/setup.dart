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

final playerKnobs = <int, List<double>>{};

final Map<int, bool> attackCooldowns = {};
final Map<int, bool> dashCooldowns = {};

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

Map<int, Player> spectatorsTeam = {};
Map<int, Player> materialTeam = {};
Map<int, Player> cupertinoTeam = {};
Map<int, Player> fluentTeam = {};

Map<Team, Map<int, Player>> teams = {
  Team.spectator: spectatorsTeam,
  Team.material: materialTeam,
  Team.cupertino: cupertinoTeam,
  Team.fluent: fluentTeam,
};

int ids = 0;

GamePhase phase = GamePhase.selectingTeam;

Player? gameHost;

List<WebSocketChannel> rawDataWSChannels = [];
List<WebSocketChannel> playersWSChannels = [];
List<WebSocketChannel> playerChangeWSChannels = [];
List<WebSocketChannel> attackWSChannels = [];
List<WebSocketChannel> hitWSChannels = [];
Map<int, WebSocketChannel> cooldownWSChannels = {};
Map<int, WebSocketChannel> deadWSChannels = {};
Map<int, WebSocketChannel> teamsWSChannels = {};
Map<int, WebSocketChannel> gamePhaseWSChannels = {};

// If there are lags, try make sliceTime smaller
const int sliceTime = 5000;

const double normalSpeed = 0.00001;
const double dashSpeed = 0.00005;
const double frameWidth = 750.0;
const double frameHeight = 550.0;
const int attackCooldownSesconds = 2;
const int dashCooldownSesconds = 1;

TeamsDto prepareTeams() => TeamsDto(
      material: materialTeam.values.map((e) => e.nick).toList(),
      cupertino: cupertinoTeam.values.map((e) => e.nick).toList(),
      fluent: fluentTeam.values.map((e) => e.nick).toList(),
      spectators: materialTeam.values.map((e) => e.nick).toList(),
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
  playerPositions.remove(id);
  playerKnobs.remove(id);
  spectatorsTeam.remove(id);
  materialTeam.remove(id);
  cupertinoTeam.remove(id);
  fluentTeam.remove(id);
  final player = players.remove(id);

  sharePlayers();
  shareTeams();
  if (player != null) {
    sharePlayerRemoved(player);
  }
}
