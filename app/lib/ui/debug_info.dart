import 'package:bubble_fight/server_client.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class DebugInfo extends StatelessWidget {
  final _client = GetIt.I<ServerClient>();

  DebugInfo({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: StreamBuilder<List<Player>>(
          stream: _client.players$(),
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
