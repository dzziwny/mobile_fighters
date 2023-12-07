import 'package:core/core.dart';

import 'game_state_ws.dart';

class GameStateService {
  final gameData = GameData();
  final gameState = GameState.empty();

  GameStateService() {
    gameDataWs.data().listen(
      (state) {
        for (var i = 0; i < gameSettings.maxPlayers; i++) {
          gameData.players[i].device = state.players[i].device;
          gameData.players[i].isActive = state.players[i].isActive;
          gameData.players[i].nick = state.players[i].nick;
          gameData.players[i].team = state.players[i].team;
        }
      },
    );

    gameStateWs.data().listen(
      (state) {
        for (var i = 0; i < gameSettings.maxPlayers; i++) {
          gameState.players[i].x = state.players[i].x;
          gameState.players[i].y = state.players[i].y;
          gameState.players[i].angle = state.players[i].angle;
          gameState.players[i].hp = state.players[i].hp;
          gameState.players[i].isDashCooldown = state.players[i].isDashCooldown;
          gameState.players[i].isBombCooldown = state.players[i].isBombCooldown;
          gameState.players[i].isDashActive = state.players[i].isDashActive;
          gameState.hits[i] = state.hits[i];
        }

        for (var i = 0; i < gameSettings.maxBullets; i++) {
          gameState.bullets[i].position.x = state.bullets[i].position.x;
          gameState.bullets[i].position.y = state.bullets[i].position.y;
          gameState.bullets[i].angle = state.bullets[i].angle;
        }

        for (var i = 0; i < gameSettings.maxBombs; i++) {
          gameState.bombs[i].x = state.bombs[i].x;
          gameState.bombs[i].y = state.bombs[i].y;
        }
      },
    );
  }
}

final gameService = GameStateService();
