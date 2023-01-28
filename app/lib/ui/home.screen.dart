import 'package:bubble_fight/consts.dart';
import 'package:bubble_fight/di.dart';
import 'package:bubble_fight/statics.dart';
import 'package:bubble_fight/ui/bubble_game.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'controls_layer.dart';
import 'nick_window_layer.dart';
import 'rail.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Rail(),
          Expanded(
            child: Stack(
              children: [
                Positioned.fill(
                  child: FittedBox(
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: borderWidth,
                      height: borderHeight,
                      child: FutureBuilder<GameFrame>(
                          future: serverClient.gameFrame,
                          builder: (context, snapshot) {
                            final frame = snapshot.data;
                            if (frame == null) {
                              return const SizedBox.shrink();
                            }

                            double frameWidth =
                                frame.sizex + borderHorizontalPadding * 2;
                            double frameHeight =
                                frame.sizey + borderVerticalPadding * 2;
                            return StreamBuilder<Position>(
                                stream: serverClient.myPosition$,
                                builder: (context, snapshot) {
                                  final position = snapshot.data;
                                  double x = 0.0;
                                  double y = 0.0;

                                  if (position != null) {
                                    x = (position.x - frame.sizex / 2) /
                                        ((frameWidth - borderWidth) / 2);
                                    y = (position.y - frame.sizey / 2) /
                                        ((frameHeight - borderHeight) / 2);
                                  }

                                  return ClipRect(
                                    child: OverflowBox(
                                      maxWidth: double.infinity,
                                      maxHeight: double.infinity,
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
                  stream: serverClient.isInGame(),
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
                    child: const NickWindowLayer(),
                  ),
                ),
                Positioned(
                  bottom: 20.0,
                  right: 20.0,
                  child: Row(
                    children: [
                      StreamBuilder<bool>(
                        stream: serverClient.cooldown$
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
                                isCooldown ? null : () => serverClient.dash(),
                            child: const Icon(
                              Icons.rocket_launch,
                            ),
                          );
                        },
                      ),
                      StreamBuilder<bool>(
                        stream: serverClient.cooldown$
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
                                isCooldown ? null : () => serverClient.attack(),
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
