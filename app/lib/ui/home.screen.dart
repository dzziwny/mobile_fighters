import 'dart:async';
import 'dart:io';

import 'package:bubble_fight/di.dart';
import 'package:bubble_fight/ui/frags_layer.dart';
import 'package:core/core.dart';
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
                const NickWindowLayer(),
                // LinesLayer(),
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
          // if (kDebug) const GamePhysicsColumn(),
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

class GamePhysicsColumn extends StatefulWidget {
  const GamePhysicsColumn({super.key});

  @override
  State<GamePhysicsColumn> createState() => _GamePhysicsColumnState();
}

class _GamePhysicsColumnState extends State<GamePhysicsColumn> {
  var gamepPhysics = GamePhysics();

  late final _kController =
      TextEditingController(text: gamepPhysics.k.toString());
  late final _nController =
      TextEditingController(text: gamepPhysics.n.toString());
  late final _fController =
      TextEditingController(text: gamepPhysics.f.toString());

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: 200.0,
      child: Column(
        children: [
          TextField(
            controller: _kController,
            onChanged: (value) {
              gamepPhysics.k = double.tryParse(value) ?? 0;
            },
          ),
          TextField(
            controller: _nController,
            onChanged: (value) {
              gamepPhysics.n = double.tryParse(value) ?? 0;
            },
          ),
          TextField(
            controller: _fController,
            onChanged: (value) {
              gamepPhysics.f = double.tryParse(value) ?? 0;
            },
          ),
          MaterialButton(
            onPressed: () async {
              await client.setGamePhysics(gamepPhysics);
              if (!mounted) {
                return;
              }

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Success')),
              );

              gameBoardFocusNode.requestFocus();
            },
            child: const Text('Apply'),
          ),
          MaterialButton(
            onPressed: () {
              exit(0);
            },
            child: const Text('Exit'),
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
    final player = gameService.gameState.players[client.id];
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
          onPressed: client.leaveGame,
          icon: const Icon(Icons.logout_rounded),
        ),
      ],
    );
  }
}
