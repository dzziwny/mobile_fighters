import 'package:bubble_fight/ui/controls_layer.dart';
import 'package:bubble_fight/ui/players_layer.dart';
import 'package:flutter/material.dart';

class BubbleGame extends StatelessWidget {
  const BubbleGame({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.white),
      // ),
      child: Stack(
        children: [
          // Container(color: Colors.grey),
          PlayersLayer(),
          const ControlsLayer(),
        ],
      ),
    );
  }
}
