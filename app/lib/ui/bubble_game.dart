import 'package:bubble_fight/server_client.dart';
import 'package:bubble_fight/ui/controls_layer.dart';
import 'package:bubble_fight/ui/players_layer.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class BubbleGame extends StatelessWidget {
  BubbleGame({super.key});

  final client = GetIt.I<ServerClient>();

  @override
  Widget build(BuildContext context) {
    return Container(
      // decoration: BoxDecoration(
      //   border: Border.all(color: Colors.white),
      // ),
      child: Stack(
        children: [
          // Container(color: Colors.grey),
          PlayersLayer(),
          StreamBuilder<bool>(
            stream: client.isInGame(),
            builder: (context, snapshot) {
              final isInGame = snapshot.data;
              if (isInGame != true) {
                return const SizedBox.shrink();
              }
              return const ControlsLayer();
            },
          )
        ],
      ),
    );
  }
}
