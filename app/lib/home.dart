import 'package:bubble_fight/60hz_refreshable_playground/playground_layer.dart';
import 'package:bubble_fight/attacks/hit_reaction_layer.dart';
import 'package:bubble_fight/attacks/sight_layer.dart';
import 'package:bubble_fight/config.dart';
import 'package:bubble_fight/controls/buttons_rail.dart';
import 'package:bubble_fight/controls/controls_layer.dart';
import 'package:bubble_fight/controls/leave_button.dart';
import 'package:bubble_fight/debug_tools/debug_game_settings.dart';
import 'package:bubble_fight/debug_tools/lines_layer.dart';
import 'package:bubble_fight/frags/frags_layer.dart';
import 'package:bubble_fight/start_window/_start_window.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({super.key});

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
                const PlaygroundLayer(),
                const HitReactionLayer(),
                if (!isMobile) const SightLayer(),
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
                if (showLeaveButton)
                  const Positioned(
                    top: 16.0,
                    right: 16.0,
                    child: LeaveButton(),
                  ),
              ],
            ),
          ),
          if (showButtonsRail) const ButtonsRail(),
          if (showDebugGameSettings) const DebugGameSettings(),
        ],
      ),
    );
  }
}
