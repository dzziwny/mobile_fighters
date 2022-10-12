import 'package:bubble_fight/server_client.dart';
import 'package:flutter/material.dart';

class LeaveButton extends StatelessWidget {
  const LeaveButton({
    Key? key,
    required this.client,
  }) : super(key: key);

  final ServerClient client;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        client.leaveGame();
      },
      icon: const Icon(Icons.exit_to_app),
      label: const Text('Leave'),
      style: const ButtonStyle(
        backgroundColor: MaterialStatePropertyAll(Colors.red),
      ),
    );
  }
}
