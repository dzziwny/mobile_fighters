import 'package:bubble_fight/bubble.game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    GameWidget(
      game: BubbleGame(),
    ),
  );
}
