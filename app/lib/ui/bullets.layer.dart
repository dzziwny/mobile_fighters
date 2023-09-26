import 'package:bubble_fight/di.dart';
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
            top: bullet.position.y - 15.0,
            left: bullet.position.x - 15.0,
            height: 30.0,
            width: 30.0,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(15.0),
              ),
            ),
          );
        },
      ).toList(),
    );
  }
}
