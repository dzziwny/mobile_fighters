import 'package:bubble_fight/bubble.game.dart';
import 'package:bubble_fight/server_client.dart';
import 'package:core/core.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

final game = BubbleGame(gameId: '');

class HomeScreen extends StatelessWidget {
  final nickController = TextEditingController();
  final client = GetIt.I<ServerClient>();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue,
      body: Row(
        children: [
          Expanded(
            child: FittedBox(
              child: SizedBox(
                width: 800,
                height: 600,
                child: Stack(
                  children: [
                    GameWidget(
                      game: game,
                    ),
                    StreamBuilder<bool>(
                      stream: client.isInGame(),
                      builder: (context, snapshot) {
                        final isInGame = snapshot.data;
                        if (isInGame == true) {
                          return const SizedBox();
                        }
                        return Center(
                          child: Container(
                            width: 200.0,
                            height: 200.0,
                            color: Colors.white,
                            child: Center(
                              child: StatefulBuilder(builder: (_, setState) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextField(
                                      controller: nickController,
                                      decoration: const InputDecoration(
                                        labelText: 'Nick',
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 2.0,
                                            color: Colors.blue,
                                          ),
                                        ),
                                      ),
                                      onChanged: (value) => setState(() {}),
                                      maxLength: 10,
                                    ),
                                    const SizedBox(height: 20.0),
                                    MaterialButton(
                                      color: Colors.blue,
                                      onPressed: nickController.text == ''
                                          ? null
                                          : () {
                                              client.createPlayer(
                                                  nickController.text);
                                            },
                                      child: const Text('Enter the game'),
                                    ),
                                  ],
                                );
                              }),
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      alignment: Alignment.topLeft,
                      child: _LeaveButton(client: client),
                    ),
                    Positioned(
                      bottom: 20.0,
                      right: 20.0,
                      child: Row(
                        children: [
                          StreamBuilder<bool>(
                            stream: client.cooldown$
                                .where((cooldown) =>
                                    cooldown.cooldownType == CooldownType.dash)
                                .map((dto) => dto.isCooldown),
                            builder: (context, snapshot) {
                              final isCooldown = snapshot.data;
                              if (isCooldown == null) {
                                return const SizedBox();
                              }
                              return ElevatedButton(
                                onPressed:
                                    isCooldown ? null : () => client.dash(),
                                child: const Icon(
                                  Icons.rocket_launch,
                                ),
                              );
                            },
                          ),
                          StreamBuilder<bool>(
                            stream: client.cooldown$
                                .where((cooldown) =>
                                    cooldown.cooldownType ==
                                    CooldownType.attack)
                                .map((dto) => dto.isCooldown),
                            builder: (context, snapshot) {
                              final isCooldown = snapshot.data;
                              if (isCooldown == null) {
                                return const SizedBox();
                              }

                              return ElevatedButton(
                                onPressed:
                                    isCooldown ? null : () => client.attack(),
                                child: const Icon(
                                  Icons.sunny,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (kDebugMode)
            SizedBox(
              width: 200.0,
              height: double.maxFinite,
              child: DebugInfo(),
            ),
        ],
      ),
    );
  }
}

class DebugInfo extends StatelessWidget {
  final _client = GetIt.I<ServerClient>();

  DebugInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: StreamBuilder<List<Player>>(
          stream: _client.players$(),
          builder: (context, snapshot) {
            final players = snapshot.data;
            if (players == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Players:',
                  style: TextStyle(color: Colors.white),
                ),
                for (final player in players)
                  Text(
                    player.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
              ],
            );
          }),
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
      },
      icon: const Icon(Icons.exit_to_app),
      label: const Text('Leave'),
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.red),
      ),
    );
  }
}
