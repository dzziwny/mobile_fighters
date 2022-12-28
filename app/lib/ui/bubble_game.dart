import 'package:bubble_fight/ui/players_layer.dart';
import 'package:flutter/material.dart';

class BubbleGame extends StatelessWidget {
  const BubbleGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 750.0,
      height: 550.0,
      decoration: BoxDecoration(
        color: Colors.amber,
        border: Border.all(color: Colors.black),
        borderRadius: const BorderRadius.all(
          Radius.circular(16.0),
        ),
      ),
      child: Stack(
        children: const [
          PlayersLayer(),
        ],
      ),
    );
  }
}
