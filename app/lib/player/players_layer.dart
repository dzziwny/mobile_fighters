import 'package:bubble_fight/consts.dart';
import 'package:bubble_fight/game_state/game_state.service.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'google_pixel_7.dart';
import 'iphone_14.dart';

class PlayersLayer extends StatelessWidget {
  const PlayersLayer({
    super.key,
    required this.theme,
    required this.gameService,
  });

  final GameStateService gameService;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
        maxPlayers,
        (id) => _Player(
          id: id,
          theme: theme,
          player: gameService.gameState.players[id],
          metadata: gameService.gameData.players[id],
        ),
      ).toList(),
    );
  }
}

class _Player extends StatelessWidget {
  _Player({
    required this.id,
    required this.theme,
    required this.player,
    required this.metadata,
  })  : color = playerColors[metadata.team.index],
        playerWidget = playerWidgets[metadata.device.index];

  final int id;
  final ThemeData theme;
  final Player metadata;
  final PlayerViewModel player;
  final Color color;
  final Widget playerWidget;

  static const _playerHeightOffest = hpBarHeight + (playerAreaHeight / 2.0);
  static const _playerWidthOffest = fullPlayerAreaWidth / 2.0;

  @override
  Widget build(BuildContext context) {
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
                    value: player.hp.toDouble(),
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
                        color: player.isDashActive ? Colors.amber : color,
                        spreadRadius: 10.0,
                        blurRadius: 25.0,
                        blurStyle: BlurStyle.normal,
                      ),
                    ],
                  ),
                  height: playerPhoneHeight,
                  width: playerPhoneWidth,
                  child: FittedBox(
                    child: Stack(
                      children: [
                        playerWidget,
                        Center(child: Text(metadata.nick)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const playerWidgets = [
  GooglePixel7(),
  IPhone14(),
];

final playerColors = [
  Colors.blue,
  Colors.red,
];