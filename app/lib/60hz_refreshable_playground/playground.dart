import 'package:bubble_fight/attacks/bombs_layer.dart';
import 'package:bubble_fight/attacks/bullets.layer.dart';
import 'package:bubble_fight/game_state/game_state.service.dart';
import 'package:bubble_fight/player/players_layer.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

class Playground extends StatelessWidget {
  const Playground({
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
      padding: EdgeInsets.symmetric(
        vertical: gameSettings.battleGroundFrameVerticalThickness,
        horizontal: gameSettings.battleGroundFrameHorizontalThickness,
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
            const _Respawns(),
            _AutoRefreshLayer(
              theme: theme,
              gameService: gameService,
            ),
          ],
        ),
      ),
    );
  }
}

class _AutoRefreshLayer extends StatelessWidget {
  const _AutoRefreshLayer({
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

class _Respawns extends StatelessWidget {
  const _Respawns();

  @override
  Widget build(BuildContext context) {
    final respWidth = gameSettings.respawnWidth.toDouble();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: respWidth,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                spreadRadius: respWidth,
                blurRadius: respWidth,
                color: Colors.blue.withOpacity(0.6),
              )
            ],
          ),
        ),
        Container(
          width: respWidth,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                spreadRadius: respWidth,
                blurRadius: respWidth,
                color: Colors.red.withOpacity(0.6),
              )
            ],
          ),
        ),
      ],
    );
  }
}
