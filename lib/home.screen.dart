import 'package:bubble_fight/bubble.game.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final controller = TextEditingController(text: '1234');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          MaterialButton(
            child: const Text('Create game'),
            onPressed: () {},
          ),
          TextField(controller: controller),
          MaterialButton(
            child: const Text('Enter the game'),
            onPressed: () {
              Navigator.of(context).push<void>(
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => GameWidget(
                    game: BubbleGame(gameId: controller.text),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
