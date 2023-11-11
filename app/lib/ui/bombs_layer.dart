import 'package:bubble_fight/bloc/game.service.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

class BombsLayer extends StatelessWidget {
  const BombsLayer({
    super.key,
    required this.gameService,
    required this.theme,
  });

  final GameService gameService;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: gameService.gameState.bombs.map((attack) {
        return Positioned(
          top: attack.y - bombRadius,
          left: attack.x - bombRadius,
          child: Card(
            shape: const CircleBorder(),
            color: theme.colorScheme.error,
            child: const SizedBox(
              height: bombDiameter,
              width: bombDiameter,
            ),
          ),
        );
      }).toList(),
    );
  }
}
