import 'package:bubble_fight/consts.dart';
import 'package:bubble_fight/server_client.dart';
import 'package:bubble_fight/statics.dart';
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
                  child: FittedBox(
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 1280,
                      height: 720,
                      child: FutureBuilder<GameFrame>(
                          future: client.gameFrame,
                          builder: (context, snapshot) {
                            final frame = snapshot.data;
                            if (frame == null) {
                              return const SizedBox.shrink();
                            }

                            double frameWidth =
                                frame.sizex + borderHorizontalPadding * 2;
                            double frameHeight =
                                frame.sizey + borderVerticalPadding * 2;
                            return LayoutBuilder(
                                builder: (context, constraints) {
                              return StreamBuilder<Position>(
                                stream: client.myPosition$,
                                builder: (context, snapshot) {
                                  final position = snapshot.data;
                                  double x = 0.0;
                                  double y = 0.0;

                                  if (position != null) {
                                    x = -(position.x - frame.sizex / 2) /
                                        ((constraints.maxWidth - frameWidth) /
                                            2);
                                    y = -(position.y - frame.sizey / 2) /
                                        ((constraints.maxHeight - frameHeight) /
                                            2);
                                  }

                                  return ClipRect(
                                    child: Align(
                                      alignment: Alignment(x, y),
                                      child: SizedBox(
                                        width: frameWidth,
                                        height: frameHeight,
                                        child: BubbleGame(
                                          boardWidth: frame.sizex,
                                          boardHeight: frame.sizey,
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            });
                          }),
                    ),
                  ),
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
