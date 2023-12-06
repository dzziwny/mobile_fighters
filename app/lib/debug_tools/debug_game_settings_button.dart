import 'package:bubble_fight/60hz_refreshable_playground/playground_layer.dart';
import 'package:bubble_fight/server_client.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'debug_game_settings.dart';

class DebugGameSettingsButton extends StatelessWidget {
  const DebugGameSettingsButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            final physics = GamePhysics();
            return AlertDialog(
              title: const Text('Settings'),
              content: DebugGameSettings(physics: physics),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                FilledButton(
                  onPressed: () async {
                    Navigator.of(context).pop();
                    serverClient.setGamePhysics(physics);
                    playgroundFocusNode.requestFocus();
                  },
                  child: const Text('Apply'),
                ),
              ],
            );
          },
        );
      },
      icon: const Icon(Icons.developer_board),
    );
  }
}
