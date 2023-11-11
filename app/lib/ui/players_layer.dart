import 'package:bubble_fight/bloc/game.service.dart';
import 'package:bubble_fight/consts.dart';
import 'package:bubble_fight/di.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

class PlayersLayer extends StatelessWidget {
  const PlayersLayer({
    super.key,
    required this.theme,
    required this.gameService,
  });

  final GameService gameService;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: List.generate(
        maxPlayers,
        (id) => _Player(
          id: id,
          theme: theme,
          gameService: gameService,
        ),
      ).toList(),
    );
  }
}

class _Player extends StatelessWidget {
  const _Player({
    required this.id,
    required this.theme,
    required this.gameService,
  });

  final int id;
  final GameService gameService;
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
