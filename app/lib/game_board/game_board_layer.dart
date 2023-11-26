import 'package:bubble_fight/60hz_refreshable_playground/playground_controls_wrapper.dart';
import 'package:bubble_fight/attacks/attack_buttons.dart';
import 'package:bubble_fight/config.dart';
import 'package:flutter/material.dart';

class PlaygroundLayer extends StatelessWidget {
  const PlaygroundLayer({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Row(
        children: [
          const Expanded(
            child: PlaygroundControlsWrapper(),
          ),
          if (showAttackButtons) AttacksButtons(theme: theme),
        ],
      ),
    );
  }
}
