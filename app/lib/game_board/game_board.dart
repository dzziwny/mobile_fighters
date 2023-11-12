import 'package:bubble_fight/game_state/game_state.service.dart';
import 'package:bubble_fight/player/players_layer.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import '../bombs/bombs_layer.dart';
import '../bullets/bullets.layer.dart';
import 'game_board_tablet_frame.dart';
import 'respawns_layer.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({
    super.key,
    required this.boardWidth,
    required this.boardHeight,
    required this.gameService,
    required this.theme,
  });

  final double boardWidth;
  final double boardHeight;
  final ThemeData theme;
  final GameStateService gameService;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GameBoardBattleGround(
          boardWidth: boardWidth,
          boardHeight: boardHeight,
          theme: theme,
          gameService: gameService,
        ),
        const GameBoardTabletFrame(),
      ],
    );
  }
}

class GameBoardBattleGround extends StatelessWidget {
  const GameBoardBattleGround({
    super.key,
    required this.boardWidth,
    required this.boardHeight,
    required this.theme,
    required this.gameService,
  });

  final double boardWidth;
  final double boardHeight;
  final ThemeData theme;
  final GameStateService gameService;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
        boxShadow: [
          BoxShadow(
            spreadRadius: 70.0,
            blurRadius: 100.0,
            blurStyle: BlurStyle.normal,
            color: Colors.green,
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        vertical: battleGroundFrameVerticalThickness,
        horizontal: battleGroundFrameHorizontalThickness,
      ),
      child: Container(
        clipBehavior: Clip.hardEdge,
        width: boardWidth,
        height: boardHeight,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/background_castle.webp'),
            // fit: BoxFit.fitHeight,
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(
            Radius.circular(16.0),
          ),
        ),
        child: Stack(
          children: [
            const RespawnsLayer(),
            AutoRefreshLayer(
              theme: theme,
              gameService: gameService,
            ),
          ],
        ),
      ),
    );
  }
}

class AutoRefreshLayer extends StatelessWidget {
  const AutoRefreshLayer({
    super.key,
    required this.theme,
    required this.gameService,
  });

  final ThemeData theme;
  final GameStateService gameService;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BombsLayer(theme: theme, gameService: gameService),
        BulletsLayer(gameService: gameService),
        PlayersLayer(theme: theme, gameService: gameService),
      ],
    );
  }
}
