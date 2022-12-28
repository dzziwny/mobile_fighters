import 'package:bubble_fight/consts.dart';
import 'package:bubble_fight/server_client.dart';
import 'package:bubble_fight/ui/bubble_game.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'controls_layer.dart';
import 'nick_window_layer.dart';
import 'rail.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final client = GetIt.I<ServerClient>();
    return Scaffold(
      body: Row(
        children: [
          Rail(),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: LayoutBuilder(builder: (context, constraints) {
                    return StreamBuilder<Position>(
                      stream: client.myPosition$,
                      builder: (context, snapshot) {
                        final position = snapshot.data;
                        double x = 0.0;
                        double y = 0.0;

                        if (position != null) {
                          x = -(position.x - 375.0) /
                              ((constraints.maxWidth - 750.0) / 2);
                          y = -(position.y - 275.0) /
                              ((constraints.maxHeight - 550.0) / 2);
                        }

                        return Align(
                          alignment: Alignment(x, y),
                          child: const SizedBox(
                            width: 750.0,
                            height: 550.0,
                            child: BubbleGame(),
                          ),
                        );
                      },
                    );
                  }),
                ),
                // Center(
                //     child: Container(
                //   color: Colors.red,
                //   height: 5.0,
                //   width: 5.0,
                // )),
                StreamBuilder<bool>(
                  stream: client.isInGame(),
                  builder: (context, snapshot) {
                    final isInGame = snapshot.data;
                    if (isInGame != true) {
                      return const SizedBox.shrink();
                    }
                    return const ControlsLayer();
                  },
                ),
                Center(
                  child: Container(
                    width: 600 * goldenRatio,
                    height: 600,
                    padding: const EdgeInsets.all(32.0),
                    child: NickWindowLayer(),
                  ),
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
