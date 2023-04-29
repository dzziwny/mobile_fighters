import 'package:bubble_fight/consts.dart';
import 'package:bubble_fight/di.dart';
import 'package:bubble_fight/ui/google_pixel_7.dart';
import 'package:bubble_fight/ui/iphone_14.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:value_stream_builder/value_stream_builder.dart';

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
          children: players.values
              .map(
                (Player player) => _Player(player: player),
              )
              .toList(),
        );
      },
    );
  }
}

class _Player extends StatelessWidget {
  const _Player({
    required this.player,
  });

  final Player player;

  static const _playerHeightOffest = hpBarHeight + (playerAreaHeight / 2.0);
  static const _playerWidthOffest = fullPlayerAreaWidth / 2.0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return StreamBuilder<PlayerPosition>(
        stream: positionBloc.position(player.id),
        builder: (context, snapshot) {
          final position = snapshot.data;
          if (position == null) {
            return const SizedBox.shrink();
          }

          return Positioned(
            top: position.y - _playerHeightOffest,
            left: position.x - _playerWidthOffest,
            child: SizedBox(
              height: fullPlayerAreaHeight,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: hpBarHeight,
                    width: fullPlayerAreaWidth,
                    child: FittedBox(
                      child: SizedBox(
                        width: 300.0,
                        child: ValueStreamBuilder<double>(
                            stream: hpBloc.get(player),
                            builder: (context, snapshot) {
                              return Slider(
                                thumbColor: theme.colorScheme.error,
                                activeColor: theme.colorScheme.error,
                                value: snapshot.data,
                                max: startHpDouble,
                                onChanged: (double value) {},
                              );
                            }),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: playerAreaHeight,
                    child: Transform.rotate(
                      angle: position.angle,
                      child: Container(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: player.team == Team.blue
                                  ? Colors.blue
                                  : Colors.red,
                              spreadRadius: 10.0,
                              blurRadius: 25.0,
                              blurStyle: BlurStyle.normal,
                            ),
                          ],
                        ),
                        height: playerPhoneHeight,
                        width: playerPhoneWidth,
                        child: FittedBox(child: deviceWidget(player.device)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
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
