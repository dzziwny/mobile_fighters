import 'package:bubble_fight/server_client.dart';
import 'package:bubble_fight/ui/google_pixel_7.dart';
import 'package:bubble_fight/ui/iphone_14.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';

class PlayersLayer extends StatelessWidget {
  const PlayersLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final client = GetIt.I<ServerClient>();
    return StreamBuilder<Widget>(
      stream: Rx.combineLatest2(
        client.players$,
        client.positions$,
        (List<Player> players, Map<int, Position> positions) {
          return Stack(
            children: players.map(
              (player) {
                final position = positions[player.id];
                if (position == null) {
                  return const SizedBox.shrink();
                }

                return Positioned(
                  top: position.y - 72.0,
                  left: position.x - 44.5,
                  child: Transform.rotate(
                    angle: position.angle,
                    child: SizedBox(
                      height: 144.0,
                      width: 89.0,
                      child: FittedBox(child: deviceWidget(player.device)),
                    ),
                  ),
                );
              },
            ).toList(),
          );
        },
      ),
      builder: (context, snapshot) {
        final widget = snapshot.data;
        if (widget == null) {
          return const SizedBox.shrink();
        }

        return widget;
      },
    );
  }

  Widget deviceWidget(Device device) {
    switch (device) {
      case Device.pixel:
        return const GooglePixel7();
      case Device.iphone:
        return const IPhone14();
      default:
        throw Exception('Unknown device.');
    }
  }
}
