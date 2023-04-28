import 'dart:async';

import 'package:bubble_fight/di.dart';
import 'package:bubble_fight/ui/frags_layer.dart';
import 'package:flutter/material.dart';

import 'controls_layer.dart';
import 'game_board_layer.dart';
import 'hit_reaction_layer.dart';
import 'nick_window_layer.dart';
import 'sight_layer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final StreamSubscription myPlayerSubscription;

  @override
  void initState() {
    myPlayerSubscription = serverClient.myPlayer$.listen(
      (player) {
        if (player != null) {
          movementBloc.gameBoardFocusNode.requestFocus();
        } else {
          movementBloc.gameBoardFocusNode.unfocus();
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.onBackground,
      body: Stack(
        children: [
          const GameBoardLayer(),
          const SightLayer(),
          const MouseRegion(
            opaque: false,
            child: HitReactionLayer(),
          ),
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
          const NickWindowLayer(),
          const Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [_AttacksButtons(), SizedBox(height: 32.0)],
          ),
          const Padding(
            padding: EdgeInsets.all(32.0),
            child: Row(
              children: [
                FragsLayer(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Future<void> dispose() async {
    await myPlayerSubscription.cancel();
    super.dispose();
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
