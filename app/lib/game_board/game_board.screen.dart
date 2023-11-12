import 'dart:async';

import 'package:bubble_fight/config.dart';
import 'package:bubble_fight/controls/controls.bloc.dart';
import 'package:bubble_fight/controls/controls_layer.dart';
import 'package:bubble_fight/debug_tools/debug_game_settings.dart';
import 'package:bubble_fight/debug_tools/lines_layer.dart';
import 'package:bubble_fight/frags/frags_layer.dart';
import 'package:bubble_fight/game_state/game_state.service.dart';
import 'package:bubble_fight/server_client.dart';
import 'package:bubble_fight/start_window/_start_window.dart';
import 'package:flutter/material.dart';

import 'game_board_layer.dart';
import 'hit_reaction_layer.dart';
import 'sight_layer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final StreamSubscription myPlayerSubscription;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.onBackground,
      body: Row(
        children: [
          Expanded(
            child: Stack(
              children: [
                const GameBoardLayer(),
                if (!isMobile) const SightLayer(),
                const HitReactionLayer(),
                const ControlsLayer(),
                const StartWindowLayer(),
                if (showDebugLines) const LinesLayer(),
                // Column(
                //   mainAxisAlignment: MainAxisAlignment.end,
                //   children: [_AttacksButtons(), SizedBox(height: 32.0)],
                // ),
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
          ),
          if (showDebugGameSettings) const DebugGameSettings(),
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
    final player = gameService.gameState.players[serverClient.id];
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          color: theme.colorScheme.background,
          onPressed: player.isDashCooldown == 1 ? null : controlsBloc.dash,
          icon: const Icon(Icons.rocket_launch),
        ),
        const SizedBox(width: 32.0),
        IconButton(
          color: theme.colorScheme.background,
          onPressed: player.isBombCooldown == 1 ? null : controlsBloc.startBomb,
          icon: const Icon(Icons.sunny),
        ),
        const SizedBox(width: 32.0),
        IconButton(
          color: theme.colorScheme.background,
          onPressed: serverClient.leaveGame,
          icon: const Icon(Icons.logout_rounded),
        ),
      ],
    );
  }
}
