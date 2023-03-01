import 'package:bubble_fight/di.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

class DebugInfo extends StatelessWidget {
  const DebugInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: StreamBuilder<Map<int, Player>>(
          stream: playersWs.data(),
          builder: (context, snapshot) {
            final players = snapshot.data;
            if (players == null) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Players:',
                  style: TextStyle(color: Colors.white),
                ),
                for (final player in players.values)
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
