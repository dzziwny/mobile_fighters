import 'package:bubble_fight/game_state/game_state.service.dart';
import 'package:bubble_fight/server_client.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'playground.dart';
import 'playground_tablet_frame.dart';

class PlaygroundAutoRefreshWrapper extends StatefulWidget {
  const PlaygroundAutoRefreshWrapper({
    super.key,
    required this.frameWidth,
    required this.frameHeight,
    required this.frame,
    required this.theme,
    required this.playerOffsetx,
    required this.playerOffsety,
    required this.frameOffsetx,
    required this.frameOffsety,
  });

  final double frameWidth;
  final double frameHeight;
  final ThemeData theme;
  final GameFrame frame;

  final double playerOffsetx;
  final double playerOffsety;
  final double frameOffsetx;
  final double frameOffsety;

  @override
  State<PlaygroundAutoRefreshWrapper> createState() =>
      _PlaygroundStateAutoRefreshWrapper();
}

class _PlaygroundStateAutoRefreshWrapper
    extends State<PlaygroundAutoRefreshWrapper> with TickerProviderStateMixin {
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) => setState(() {}));
    _ticker.start();
  }

  @override
  Widget build(BuildContext context) {
    final player = gameService.gameState.players[serverClient.id];
    var x = (player.x - widget.playerOffsetx) / widget.frameOffsetx;
    var y = (player.y - widget.playerOffsety) / widget.frameOffsety;
    return OverflowBox(
      maxWidth: double.infinity,
      maxHeight: double.infinity,
      alignment: Alignment(x, y),
      child: SizedBox(
        width: widget.frameWidth,
        height: widget.frameHeight,
        child: Stack(
          children: [
            Playground(
              boardWidth: widget.frame.sizex + 0.0,
              boardHeight: widget.frame.sizey + 0.0,
              theme: widget.theme,
              gameService: gameService,
            ),
            const PlaygroundTabletFrame(),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }
}
