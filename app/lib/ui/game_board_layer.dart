import 'package:bubble_fight/di.dart';
import 'package:bubble_fight/ui/game_board.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math.dart';

class GameBoardLayer extends StatelessWidget {
  const GameBoardLayer({super.key});

  void onPointerMove(PointerEvent event, double halfWidth, double halfHeight) {
    final x = event.position.dx - halfWidth;
    final y = event.position.dy - halfHeight;
    final angle =
        (Vector2(x, y).clone()..y *= -1).angleToSigned(Vector2(0.0, 1.0));

    controlsBloc.rotate(angle);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    final halfScreenWidth = mediaQuery.size.width / 2;
    final halfScreenHeight = mediaQuery.size.height / 2;
    const frame = GameFrame(
      sizex: battleGroundWidth,
      sizey: battleGroundHeight,
    );

    double frameWidth = frame.sizex + battleGroundFrameHorizontalThickness * 2;
    double frameHeight = frame.sizey + battleGroundFrameVerticalThickness * 2;

    return Positioned.fill(
      child: Listener(
        onPointerDown: (_) => controlsBloc.startGun(),
        onPointerUp: (_) => controlsBloc.stopGun(),
        onPointerMove: isMobile
            ? null
            : (PointerMoveEvent event) =>
                onPointerMove(event, halfScreenWidth, halfScreenHeight),
        onPointerHover: isMobile
            ? null
            : (PointerHoverEvent event) =>
                onPointerMove(event, halfScreenWidth, halfScreenHeight),
        child: KeyboardListener(
          focusNode: gameBoardFocusNode,
          child: FittedBox(
            fit: BoxFit.contain,
            alignment: Alignment.center,
            child: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/cosmos_background.gif"),
                ),
              ),
              width: screenWidth,
              height: screenHeight,
              child: ClipRect(
                child: ClippedBoard(
                  frameWidth: frameWidth,
                  frameHeight: frameHeight,
                  theme: theme,
                  frame: frame,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ClippedBoard extends StatefulWidget {
  ClippedBoard({
    super.key,
    required this.frameWidth,
    required this.frameHeight,
    required this.frame,
    required this.theme,
  });

  final double frameWidth;
  final double frameHeight;
  final ThemeData theme;
  final GameFrame frame;

  late final playerOffsetx = frame.sizex / 2;
  late final playerOffsety = frame.sizey / 2;
  late final frameOffsetx = (frameWidth - screenWidth) / 2;
  late final frameOffsety = (frameHeight - screenHeight) / 2;

  @override
  State<ClippedBoard> createState() => _ClippedBoardState();
}

class _ClippedBoardState extends State<ClippedBoard>
    with TickerProviderStateMixin {
  late final Ticker _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((_) => setState(() {}));
    _ticker.start();
  }

  @override
  Widget build(BuildContext context) {
    final player = gameService.gameState.players[client.id];
    var x = (player.x - widget.playerOffsetx) / widget.frameOffsetx;
    var y = (player.y - widget.playerOffsety) / widget.frameOffsety;
    return OverflowBox(
      maxWidth: double.infinity,
      maxHeight: double.infinity,
      alignment: Alignment(x, y),
      child: SizedBox(
        width: widget.frameWidth,
        height: widget.frameHeight,
        child: GameBoard(
          boardWidth: widget.frame.sizex + 0.0,
          boardHeight: widget.frame.sizey + 0.0,
          theme: widget.theme,
          gameService: gameService,
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
