import 'package:bubble_fight/di.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

class AttacksBottomLayer extends StatelessWidget {
  const AttacksBottomLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: gameService.gameState.bombs.map((attack) {
        return Card(
          shape: const CircleBorder(),
          color: theme.colorScheme.error,
          child: const SizedBox(
            height: attackAreaDiameter,
            width: attackAreaDiameter,
          ),
        );
      }).toList(),
    );
  }
}
