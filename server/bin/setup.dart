import 'dart:collection';

import 'package:core/core.dart';

import 'main.dart';
import 'register_di.dart';

final guids = <String, int>{};
final playerMetadatas =
    UnmodifiableListView(List.generate(gameSettings.maxPlayers, Player.empty));
final bullets =
    UnmodifiableListView(List.generate(gameSettings.maxBullets, Bullet.empty));
final currentBullets = List.generate(
    gameSettings.maxPlayers, (i) => i * gameSettings.maxBullePerPlayer);
final bombs =
    UnmodifiableListView(List.generate(gameSettings.maxBombs, Bomb.empty));
final currentBombs = List.generate(
    gameSettings.maxPlayers, (i) => i * gameSettings.maxBombsPerPlayer);
final players =
    UnmodifiableListView(List.generate(gameSettings.maxPlayers, Player.empty));
final frags = List.filled(gameSettings.maxPlayers, 0);
final hits = List.filled(gameSettings.maxPlayers, 0);
final actions = UnmodifiableListView(
    List.generate(gameSettings.maxPlayers, (id) => ActionsState(id)));

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
  players[id].deactivate();
  playerMetadatas[id].deactivate();
  redTeam.remove(id);
  blueTeam.remove(id);
  guids.removeWhere((key, value) => value == id);

  final isAnyPlayer = players.any((player) => player.isActive);
  if (!isAnyPlayer) {
    stopGame();
  }

  shareGameData();
}
