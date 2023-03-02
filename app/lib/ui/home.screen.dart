import 'package:bubble_fight/consts.dart';
import 'package:bubble_fight/di.dart';
import 'package:bubble_fight/statics.dart';
import 'package:bubble_fight/ui/bubble_game.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'controls_layer.dart';
import 'nick_window_layer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.onBackground,
      body: Stack(
        children: [
          const _Game(),
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
          const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [_AttacksButtons(), SizedBox(height: 32.0)],
          ),
        ],
      ),
    );
  }
}

class _AttacksButtons extends StatelessWidget {
  const _AttacksButtons();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        StreamBuilder<bool>(
          stream: cooldownService.dash(),
          builder: (context, snapshot) {
            final isCooldown = snapshot.data;
            return IconButton(
              color: theme.colorScheme.background,
              onPressed: isCooldown == true ? null : () => positionBloc.dash(),
              icon: const Icon(Icons.rocket_launch),
            );
          },
        ),
        const SizedBox(width: 32.0),
        StreamBuilder<bool>(
          stream: cooldownService.attack(),
          builder: (context, snapshot) {
            final isCooldown = snapshot.data;
            return IconButton(
              color: theme.colorScheme.background,
              onPressed: isCooldown == true ? null : () => attackBloc.attack(),
              icon: const Icon(Icons.sunny),
            );
          },
        ),
        const SizedBox(width: 32.0),
        IconButton(
          color: theme.colorScheme.background,
          onPressed: () => serverClient.leaveGame(),
          icon: const Icon(Icons.logout_rounded),
        ),
      ],
    );
  }
}

class _Game extends StatelessWidget {
  const _Game();

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
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

                double frameWidth = frame.sizex + borderHorizontalPadding * 2;
                double frameHeight = frame.sizey + borderVerticalPadding * 2;
                return StreamBuilder<Position>(
                    stream: positionBloc.myPosition$(),
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
    );
  }
}
