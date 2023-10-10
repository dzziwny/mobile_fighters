import 'package:bubble_fight/ui/players_layer.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'bombs_layer.dart';
import 'bullets.layer.dart';
import 'respawns_layer.dart';

class GameBoard extends StatelessWidget {
  const GameBoard({
    super.key,
    required this.boardWidth,
    required this.boardHeight,
  });

  final double boardWidth;
  final double boardHeight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
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
            child: const Stack(
              children: [
                RespawnsLayer(),
                BombsLayer(),
                BulletsLayer(),
                PlayersLayer(),
              ],
            ),
          ),
        ),
        const GameBoardTabletFrame(),
      ],
    );
  }
}

class GameBoardTabletFrame extends StatelessWidget {
  const GameBoardTabletFrame({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(left: 10.0, right: 15.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Tablet frame home button
          Container(
            height: 20.0,
            width: 20.0,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: const BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
          // Tablet frame camera
          Container(
            height: 10.0,
            width: 10.0,
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: const BorderRadius.all(Radius.circular(5.0)),
            ),
            alignment: Alignment.center,
            child: Container(
              height: 5.0,
              width: 5.0,
              decoration: BoxDecoration(
                color: Colors.blue.shade900,
                borderRadius: const BorderRadius.all(Radius.circular(2.5)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}