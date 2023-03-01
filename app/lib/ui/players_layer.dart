import 'package:bubble_fight/di.dart';
import 'package:bubble_fight/ui/google_pixel_7.dart';
import 'package:bubble_fight/ui/iphone_14.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

class PlayersLayer extends StatelessWidget {
  const PlayersLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Map<int, Player>>(
      stream: playersWs.data(),
      builder: (context, snapshot) {
        final players = snapshot.data;
        if (players == null) {
          return const SizedBox.shrink();
        }

        return Stack(
          children: players.values.map(
            (Player player) {
              return StreamBuilder<Position>(
                  stream: positionBloc.position(player.id),
                  builder: (context, snapshot) {
                    final position = snapshot.data;
                    if (position == null) {
                      return const SizedBox.shrink();
                    }

                    return Positioned(
                      top: position.y - 72.0,
                      left: position.x - 44.5,
                      child: Transform.rotate(
                        angle: position.angle,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              // TODO different color for different team
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.4),
                                spreadRadius: 10.0,
                                blurRadius: 25.0,
                                blurStyle: BlurStyle.normal,
                              )
                            ],
                          ),
                          height: 144.0,
                          width: 89.0,
                          child: FittedBox(child: deviceWidget(player.device)),
                        ),
                      ),
                    );
                  });
            },
          ).toList(),
        );
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
