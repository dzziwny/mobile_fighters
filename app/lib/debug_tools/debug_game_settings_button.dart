import 'package:bubble_fight/60hz_refreshable_playground/playground_layer.dart';
import 'package:bubble_fight/server_client.dart';
import 'package:flutter/material.dart';

import 'debug_game_settings.dart';

class DebugGameSettingsButton extends StatefulWidget {
  const DebugGameSettingsButton({super.key});

  @override
  State<DebugGameSettingsButton> createState() =>
      _DebugGameSettingsButtonState();
}

class _DebugGameSettingsButtonState extends State<DebugGameSettingsButton> {
  final _controller = DebugGameSettingsController();

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: const Text('Settings'),
              content: DebugGameSettings(controller: _controller),
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
                    serverClient.setGameSettings(_controller.settings);
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
