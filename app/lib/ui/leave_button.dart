import 'package:bubble_fight/di.dart';
import 'package:flutter/material.dart';

class LeaveButton extends StatelessWidget {
  const LeaveButton({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () => serverClient.leaveGame(),
      icon: const Icon(Icons.exit_to_app),
      label: const Text('Leave'),
    );
  }
}
