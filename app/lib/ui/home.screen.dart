// import 'package:bubble_fight/ui/bubble.game.dart';
import 'package:bubble_fight/consts.dart';
import 'package:bubble_fight/server_client.dart';
import 'package:bubble_fight/ui/bubble_game.dart';
import 'package:core/core.dart';
// import 'package:flame/game.dart';
// import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

// import 'debug_info.dart';
import 'leave_button.dart';
import 'nick_window.dart';
import 'nick_window_layer.dart';
import 'rail.dart';
import 'selecting_table_layer.dart';
import 'selecting_team_table.dart';

// final game = BubbleFlameGame(gameId: '');

class HomeScreen extends StatelessWidget {
  final client = GetIt.I<ServerClient>();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Rail(),
          Expanded(
            child: Stack(
              children: [
                // GameWidget(game: game),
                Center(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: Container(
                      width: 750,
                      height: 550,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(16.0),
                        ),
                      ),
                      child: BubbleGame(),
                    ),
                  ),
                ),
                // const SelectingTableLayer(),
                Center(
                  child: Container(
                    width: 600 * goldenRatio,
                    height: 600,
                    padding: const EdgeInsets.all(32.0),
                    child: NickWindowLayer(),
                  ),
                ),
                // Container(
                //   margin: const EdgeInsets.all(8.0),
                //   alignment: Alignment.topLeft,
                //   child: LeaveButton(client: client),
                // ),
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
                            onPressed: isCooldown ? null : () => client.dash(),
                            child: const Icon(
                              Icons.rocket_launch,
                            ),
                          );
                        },
                      ),
                      StreamBuilder<bool>(
                        stream: client.cooldown$
                            .where((cooldown) =>
                                cooldown.cooldownType == CooldownType.attack)
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
        ],
      ),
    );
  }
}
