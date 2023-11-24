import 'package:bubble_fight/config.dart';
import 'package:bubble_fight/controls/controls_layer.dart';
import 'package:bubble_fight/debug_tools/debug_game_settings.dart';
import 'package:bubble_fight/debug_tools/lines_layer.dart';
import 'package:bubble_fight/frags/frags_layer.dart';
import 'package:bubble_fight/start_window/_start_window.dart';
import 'package:flutter/material.dart';

import 'game_board_layer.dart';
import 'hit_reaction_layer.dart';
import 'sight_layer.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
                Playground(theme: theme),
                if (!isMobile) const SightLayer(),
                const HitReactionLayer(),
                const ControlsLayer(),
                const StartWindowLayer(),
                if (showDebugLines) const LinesLayer(),
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
}
