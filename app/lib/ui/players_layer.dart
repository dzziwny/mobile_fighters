import 'package:bubble_fight/consts.dart';
import 'package:bubble_fight/di.dart';
import 'package:bubble_fight/ui/google_pixel_7.dart';
import 'package:bubble_fight/ui/iphone_14.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'auto_refresh_state.dart';

class PlayersLayer extends StatefulWidget {
  const PlayersLayer({super.key});

  @override
  State<PlayersLayer> createState() => _PlayersLayerState();
}

class _PlayersLayerState extends AutoRefreshState<PlayersLayer> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Stack(
      children: List.generate(
        maxPlayers,
        (id) => _Player(id: id, theme: theme),
      ).toList(),
    );
  }
}

class _Player extends StatelessWidget {
  const _Player({
    required this.id,
    required this.theme,
  });

  final int id;
  final ThemeData theme;

  static const _playerHeightOffest = hpBarHeight + (playerAreaHeight / 2.0);
  static const _playerWidthOffest = fullPlayerAreaWidth / 2.0;

  @override
  Widget build(BuildContext context) {
    final player = gameService.gameState.players[id];
    final metadata = gameService.gameData.players[id];
    return Positioned(
      top: player.y - _Player._playerHeightOffest,
      left: player.x - _Player._playerWidthOffest,
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
                  child: Slider(
                    thumbColor: theme.colorScheme.error,
                    activeColor: theme.colorScheme.error,
                    value:
                        gameService.gameState.players[player.id].hp.toDouble(),
                    max: startHp,
                    onChanged: (double value) {},
                  ),
                ),
              ),
            ),
            SizedBox(
              height: playerAreaHeight,
              child: Transform.rotate(
                angle: player.angle,
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: playerColors[metadata.team.index],
                        spreadRadius: 10.0,
                        blurRadius: 25.0,
                        blurStyle: BlurStyle.normal,
                      ),
                    ],
                  ),
                  height: playerPhoneHeight,
                  width: playerPhoneWidth,
                  child: FittedBox(child: playerWidgets[metadata.device.index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
