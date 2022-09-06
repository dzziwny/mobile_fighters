import 'package:bubble_fight/bubble.game.dart';
import 'package:bubble_fight/server/server_client.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final controller = TextEditingController(text: '1234');
  final client = GetIt.I<ServerClient>();

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
                  builder: (BuildContext context) => Stack(
                    children: [
                      GameWidget(
                        game: BubbleGame(gameId: controller.text),
                      ),
                      Container(
                        margin: const EdgeInsets.all(8.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: ElevatedButton.icon(
                            onPressed: () {
                              client.leaveGame();
                            },
                            icon: const Icon(Icons.exit_to_app),
                            label: const Text('Leave'),
                          ),
                        ),
                      ),
                    ],
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
