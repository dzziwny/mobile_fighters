import 'package:bubble_fight/bubble.game.dart';
import 'package:bubble_fight/server_client.dart';
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
                  builder: (BuildContext context) => Scaffold(
                    body: Stack(
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 800.0,
                              child: GameWidget(
                                game: BubbleGame(gameId: controller.text),
                              ),
                            ),
                            const Expanded(
                              child: DebugInfo(),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.all(8.0),
                          alignment: Alignment.topLeft,
                          child: _LeaveButton(client: client),
                        ),
                      ],
                    ),
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

class DebugInfo extends StatelessWidget {
  const DebugInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Players: [bla, blab, dajsk]',
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }
}

class _LeaveButton extends StatelessWidget {
  const _LeaveButton({
    Key? key,
    required this.client,
  }) : super(key: key);

  final ServerClient client;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        client.leaveGame();
        Navigator.of(context).pop();
      },
      icon: const Icon(Icons.exit_to_app),
      label: const Text('Leave'),
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.red),
      ),
    );
  }
}
