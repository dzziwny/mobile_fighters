import 'package:bubble_fight/ui/bubble.game.dart';
import 'package:bubble_fight/server_client.dart';
import 'package:core/core.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'debug_info.dart';
import 'leave_button.dart';
import 'nick_window.dart';

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
                              child: NickWindow(
                                  nickController: nickController,
                                  client: client),
                            ),
                          ),
                        );
                      },
                    ),
                    Container(
                      margin: const EdgeInsets.all(8.0),
                      alignment: Alignment.topLeft,
                      child: LeaveButton(client: client),
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
