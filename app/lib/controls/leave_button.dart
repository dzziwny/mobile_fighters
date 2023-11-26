import 'package:bubble_fight/server_client.dart';
import 'package:bubble_fight/start_window/start_window.controller.dart';
import 'package:flutter/material.dart';

class LeaveButton extends StatelessWidget {
  const LeaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton.filledTonal(
      onPressed: () {
        serverClient.leaveGame();
        startWindowController.set(true);
      },
      icon: const Icon(Icons.exit_to_app),
    );
  }
}
