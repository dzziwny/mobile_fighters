import 'package:bubble_fight/game_state/game_state.service.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

class BulletsLayer extends StatelessWidget {
  const BulletsLayer({super.key, required this.gameService});

  final GameStateService gameService;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: gameService.gameState.bullets.map(
        (bullet) {
          return Positioned(
            top: bullet.position.y - bulletRadius,
            left: bullet.position.x - bulletRadius,
            height: bulletDiameter,
            width: bulletDiameter,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.all(
                  Radius.circular(bulletRadius),
                ),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
