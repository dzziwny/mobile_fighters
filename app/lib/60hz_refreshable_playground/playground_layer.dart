import 'package:bubble_fight/60hz_refreshable_playground/playground_control_wrapper.dart';
import 'package:flutter/material.dart';

class PlaygroundLayer extends StatelessWidget {
  const PlaygroundLayer({super.key, required this.theme});

  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return const Center(child: PlaygroundControlWrapper());
  }
}
