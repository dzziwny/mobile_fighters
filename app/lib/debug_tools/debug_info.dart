import 'package:bubble_fight/game_state/game_state_ws.dart';
import 'package:flutter/material.dart';

class DebugInfo extends StatelessWidget {
  const DebugInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: StreamBuilder(
          stream: gameDataWs.data(),
          builder: (context, snapshot) {
            final game = snapshot.data;
            if (game == null) {
              return const Center(child: CircularProgressIndicator());
            }

            final players = game.players;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Players:',
                  style: TextStyle(color: Colors.white),
                ),
                for (final player in players)
                  Text(
                    player.toString(),
                    style: const TextStyle(color: Colors.white),
                  ),
              ],
            );
          }),
    );
  }
}
