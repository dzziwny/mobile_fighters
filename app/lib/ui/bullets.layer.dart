import 'package:bubble_fight/di.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'auto_refresh_state.dart';

class BulletsLayer extends StatefulWidget {
  const BulletsLayer({super.key});

  @override
  State<BulletsLayer> createState() => _BulletsLayerState();
}

class _BulletsLayerState extends AutoRefreshState<BulletsLayer> {
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
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(bulletRadius),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
