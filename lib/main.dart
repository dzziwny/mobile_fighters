import 'package:bubble_fight/bubble.game.dart';
import 'package:bubble_fight/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(
    GameWidget(
      game: BubbleGame(),
    ),
  );
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}
