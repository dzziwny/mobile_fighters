import 'package:bubble_fight/game_state/game_state.service.dart';
import 'package:bubble_fight/game_ui_settings.dart';
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
        gameSettings.maxPlayers,
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

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: player.y - gameUISettings.playerHeightOffest,
      left: player.x - gameUISettings.playerWidthOffest,
      child: SizedBox(
        height: gameUISettings.fullPlayerAreaHeight,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: gameUISettings.playerNickHeight,
              width: gameUISettings.fullPlayerAreaWidth,
              child: FittedBox(
                child: Text(
                  metadata.nick,
                  style: const TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.w600,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            SizedBox(height: gameUISettings.hpBarNickSpace),
            SizedBox(
              height: gameUISettings.hpBarHeight,
              width: gameUISettings.fullPlayerAreaWidth,
              child: FittedBox(
                child: SizedBox(
                  width: 300.0,
                  child: Slider(
                    thumbColor: theme.colorScheme.error,
                    activeColor: theme.colorScheme.error,
                    value: player.hp.toDouble(),
                    max: gameSettings.playerStartHp,
                    onChanged: (double value) {},
                  ),
                ),
              ),
            ),
            SizedBox(height: gameUISettings.nickCharacterSpace),
            SizedBox(
              height: gameUISettings.playerPhoneHeight,
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
                  height: gameUISettings.playerPhoneHeight,
                  width: gameUISettings.playerPhoneWidth,
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
