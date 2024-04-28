import 'dart:collection';
import 'dart:math';

import 'package:core/core.dart';

import 'ammunition/ammunition.physic.dart';
import 'ammunition/bomb_loop.dart';
import 'ammunition/bullet_loop.dart';
import 'ammunition/dash_loop.dart';
import 'register_di.dart';
import 'updates/player_physic.update.dart';

class Game {
  final guids = <String, int>{};
  final playerMetadatas = UnmodifiableListView(
    List.generate(gameSettings.maxPlayers, Player.empty),
  );
  final players = UnmodifiableListView(
    List.generate(gameSettings.maxPlayers, Player.empty),
  );
  final bullets = UnmodifiableListView(
    List.generate(gameSettings.maxBullets, Bullet.empty),
  );
  final bombs = UnmodifiableListView(
    List.generate(gameSettings.maxBombs, Bomb.empty),
  );
  final currentBullets = List.generate(
    gameSettings.maxPlayers,
    (i) => i * gameSettings.maxBullePerPlayer,
  );
  final currentBombs = List.generate(
    gameSettings.maxPlayers,
    (i) => i * gameSettings.maxBombsPerPlayer,
  );
  final frags = List.filled(gameSettings.maxPlayers, 0);
  final hits = List.filled(gameSettings.maxPlayers, 0);
  final actions = UnmodifiableListView(
    List.generate(gameSettings.maxPlayers, (id) => ActionsState(id)),
  );
  Map<int, Player> redTeam = {};
  Map<int, Player> blueTeam = {};
  GamePhase phase = GamePhase.selectingTeam;
  Player? gameHost;

  late Map<Team, Map<int, Player>> teams = {
    Team.red: redTeam,
    Team.blue: blueTeam,
  };

  void removePlayer(int id) {
    players[id].deactivate();
    playerMetadatas[id].deactivate();
    redTeam.remove(id);
    blueTeam.remove(id);
    guids.removeWhere((key, value) => value == id);
  }

  int? assignPlayerId() {
    for (var i = 0; i < gameSettings.maxPlayers; i++) {
      if (!playerMetadatas[i].isActive) {
        playerMetadatas[i].isActive = true;
        return i;
      }
    }

    return null;
  }

  Future<void> createPlayer(int id, PlayToServerDto dto) async {
    final team = _selectTeam(id);
    var x = Random().nextInt(gameSettings.respawnWidth);
    if (team == Team.red) {
      x = gameSettings.battleGroundWidth - x;
    }

    final y = Random().nextInt(gameSettings.battleGroundHeight);
    final angle = Random().nextInt(100) / 10.0;

    players[id]
      ..x = x.toDouble()
      ..y = y.toDouble()
      ..angle = angle
      ..isBombCooldownBit = 0
      ..isDashCooldownBit = 0
      ..nick = dto.nick
      ..team = team
      ..device = dto.device
      ..hp = gameSettings.playerStartHp
      ..isActive = true;

    shareGameData();
  }

  // TODO its not a game responsibility
  void shareGameData() {
    final gameData = GameData(players: players);
    final data = gameData.toString();
    for (final channel in gameDataChannels) {
      channel.sink.add(data);
    }
  }

  void update() {
    _executeActions();
    _physicUpdate();
  }

  void _executeActions() {
    for (var i = 0; i < gameSettings.maxPlayers; i++) {
      bulletsLoop.toggle(i, playerInputs[i].isBullet);
      bombsLoop.toggle(i, playerInputs[i].isBomb);
      dashLoop.toggle(i, playerInputs[i].isDash);
    }
  }

  void _physicUpdate() {
    for (var i = 0; i < gameSettings.maxBullets; i++) {
      ammunitionPhysicUpdate(
        ammo: bullets[i],
        dt: gameSettings.sliceTimeSeconds,
        maxDistance: gameSettings.bulletDistanceSquared,
        hitDistance: gameSettings.bulletPlayerCollisionDistanceSquare,
        power: gameSettings.bulletPower,
      );
    }

    for (var i = 0; i < gameSettings.maxBombs; i++) {
      ammunitionPhysicUpdate(
        ammo: bombs[i],
        dt: gameSettings.sliceTimeSeconds,
        maxDistance: gameSettings.bombDistanceSquared,
        hitDistance: gameSettings.bombPlayerCollisionDistanceSquare,
        power: gameSettings.bombPower,
      );
    }

    for (var i = 0; i < gameSettings.maxPlayers; i++) {
      playerPhysicUpdate(playerInputs[i]);
    }
  }

  TeamsDto prepareTeams() => TeamsDto(
        red: redTeam.values.map((e) => e.nick).toList(),
        blue: blueTeam.values.map((e) => e.nick).toList(),
      );

  Team _selectTeam(int id) => id.isEven ? Team.blue : Team.red;
}
