import 'package:bubble_fight/game_state/game_state.service.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

class BombsLayer extends StatelessWidget {
  const BombsLayer({
    super.key,
    required this.gameService,
    required this.theme,
  });

  final GameStateService gameService;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: gameService.gameState.bombs.map(
        (attack) {
          return Positioned(
            top: attack.y - gameSettings.bombRadius,
            left: attack.x - gameSettings.bombRadius,
            child: Card(
              shape: const CircleBorder(),
              color: Colors.deepPurple,
              child: SizedBox(
                height: gameSettings.bombDiameter,
                width: gameSettings.bombDiameter,
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
