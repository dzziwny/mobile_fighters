import 'dart:collection';

import 'package:core/core.dart';

import 'register_di.dart';

final guids = <String, int>{};
final playerMetadatas =
    UnmodifiableListView(List.generate(maxPlayers, Player.empty));
final bullets = UnmodifiableListView(List.generate(maxBullets, Bullet.empty));
final currentBullets = List.generate(maxPlayers, (i) => i * maxBullePerPlayer);
final bombs = UnmodifiableListView(List.generate(maxBombs, Bomb.empty));
final currentBombs = List.generate(maxPlayers, (i) => i * maxBombsPerPlayer);
final players = UnmodifiableListView(List.generate(maxPlayers, Player.empty));
final frags = List.filled(maxPlayers, 0);
final hits = List.filled(maxPlayers, 0);
final actions =
    UnmodifiableListView(List.generate(maxPlayers, (id) => ActionsState(id)));

/*
* Teams
*/

Map<int, Player> redTeam = {};
Map<int, Player> blueTeam = {};

Map<Team, Map<int, Player>> teams = {
  Team.red: redTeam,
  Team.blue: blueTeam,
};

GamePhase phase = GamePhase.selectingTeam;

Player? gameHost;

TeamsDto prepareTeams() => TeamsDto(
      red: redTeam.values.map((e) => e.nick).toList(),
      blue: blueTeam.values.map((e) => e.nick).toList(),
    );

void shareGameData() {
  final gameData = GameData(players: players);
  final data = gameData.toString();
  for (final channel in gameDataChannels) {
    channel.sink.add(data);
  }
}

void removePlayer(int id) {
  players[id].isActive = false;
  redTeam.remove(id);
  blueTeam.remove(id);

  shareGameData();
}
