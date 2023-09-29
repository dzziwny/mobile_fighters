import 'package:bubble_fight/di.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'auto_refresh_state.dart';

class BombsLayer extends StatefulWidget {
  const BombsLayer({super.key});

  @override
  State<BombsLayer> createState() => _BombsLayerState();
}

class _BombsLayerState extends AutoRefreshState<BombsLayer> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: gameService.gameState.bombs.map((attack) {
        return Positioned(
          top: attack.y.toDouble() - bombAreaRadius,
          left: attack.x.toDouble() - bombAreaRadius,
          child: Card(
            shape: const CircleBorder(),
            color: theme.colorScheme.error,
            child: const SizedBox(
              height: bombAreaDiameter,
              width: bombAreaDiameter,
            ),
          ),
        );
      }).toList(),
    );
  }
}
