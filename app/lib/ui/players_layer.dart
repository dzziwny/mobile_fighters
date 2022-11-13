import 'package:bubble_fight/server_client.dart';
import 'package:bubble_fight/ui/google_pixel_7.dart';
import 'package:bubble_fight/ui/player_widget.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class PlayersLayer extends StatelessWidget {
  PlayersLayer({super.key});

  final client = GetIt.I<ServerClient>();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Player>>(
      stream: client.players$(),
      builder: (context, snapshot) {
        final players = snapshot.data;
        if (players == null) {
          return const SizedBox.shrink();
        }

        return Stack(
          children: players
              .map(
                (player) => StreamBuilder<Position>(
                  stream: client
                      .position$()
                      .where((position) => position.playerId == player.id),
                  builder: (context, snapshot) {
                    final position = snapshot.data;
                    if (position == null) {
                      return const SizedBox.shrink();
                    }

                    return Positioned(
                      top: position.y - 72.0,
                      left: position.x - 72.0,
                      child: Transform.rotate(
                        angle: position.angle,
                        child: SizedBox(
                          height: 144.0,
                          width: 89.0,
                          // child: PlayerWidget(player: player),
                          child: FittedBox(child: GooglePixel7()),
                        ),
                      ),
                    );
                  },
                ),
              )
              .toList(),
        );
      },
    );
  }
}
