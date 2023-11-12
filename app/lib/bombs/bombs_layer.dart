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
            top: attack.y - bombRadius,
            left: attack.x - bombRadius,
            child: const Card(
              shape: CircleBorder(),
              color: Colors.deepPurple,
              child: SizedBox(
                height: bombDiameter,
                width: bombDiameter,
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
