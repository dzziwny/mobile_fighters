import 'dart:developer';

import 'package:bubble_fight/di.dart';
import 'package:core/core.dart';

class GameService {
  final gameData = GameData();
  final gameState = GameState.empty();

  GameService() {
    gameDataWs.data().listen(
      (state) {
        for (var i = 0; i < maxPlayers; i++) {
          gameData.players[i].device = state.players[i].device;
          gameData.players[i].isActive = state.players[i].isActive;
          gameData.players[i].nick = state.players[i].nick;
          gameData.players[i].team = state.players[i].team;
        }
      },
    );

    gameStateWs.data().listen(
      (state) {
        for (var i = 0; i < maxPlayers; i++) {
          gameState.players[i].x = state.players[i].x;
          gameState.players[i].y = state.players[i].y;
          gameState.players[i].angle = state.players[i].angle;
          gameState.players[i].hp = state.players[i].hp;
          gameState.players[i].isDashCooldown = state.players[i].isDashCooldown;
          gameState.players[i].isBombCooldown = state.players[i].isBombCooldown;
        }

        for (var i = 0; i < maxBullets; i++) {
          gameState.bullets[i].position.x = state.bullets[i].position.x;
          gameState.bullets[i].position.y = state.bullets[i].position.y;
          gameState.bullets[i].angle = state.bullets[i].angle;
          gameState.bullets[i].isActive = state.bullets[i].isActive;
        }

        for (var i = 0; i < maxBombs; i++) {
          gameState.bombs[i].x = state.bombs[i].x;
          gameState.bombs[i].y = state.bombs[i].y;
          gameState.bombs[i].isActive = state.bullets[i].isActive;
        }
      },
    );
  }
}
