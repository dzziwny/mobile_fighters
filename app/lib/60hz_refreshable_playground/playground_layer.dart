import 'package:bubble_fight/config.dart';
import 'package:bubble_fight/controls/controls.bloc.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_math/vector_math.dart';

import 'playground_auto_refresh_wrapper.dart';

final playgroundFocusNode = FocusNode();

class PlaygroundLayer extends StatelessWidget {
  const PlaygroundLayer({super.key});

  void onPointerMove(PointerEvent event, double halfWidth, double halfHeight) {
    final x = event.position.dx - halfWidth;
    final y = event.position.dy - halfHeight;
    final angle =
        (Vector2(x, y).clone()..y *= -1).angleToSigned(Vector2(0.0, 1.0));

    controlsBloc.rotate(angle);
  }

  static const frame = GameFrame(
    sizex: battleGroundWidth,
    sizey: battleGroundHeight,
  );

  static double frameWidth =
      frame.sizex + battleGroundFrameHorizontalThickness * 2;
  static double frameHeight =
      frame.sizey + battleGroundFrameVerticalThickness * 2;

  static double playerOffsetx = frame.sizex / 2;
  static double playerOffsety = frame.sizey / 2;

  static double frameOffsetx = (frameWidth - screenWidth) / 2;
  static double frameOffsety = (frameHeight - screenHeight) / 2;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Positioned.fill(
      child: LayoutBuilder(builder: (context, constraints) {
        final halfScreenWidth = constraints.maxWidth / 2;
        final halfScreenHeight = constraints.maxHeight / 2;
        return Listener(
          onPointerDown: (_) => controlsBloc.startBullet(),
          onPointerUp: (_) => controlsBloc.stopBullet(),
          onPointerMove: isMobile
              ? null
              : (PointerMoveEvent event) =>
                  onPointerMove(event, halfScreenWidth, halfScreenHeight),
          onPointerHover: isMobile
              ? null
              : (PointerHoverEvent event) =>
                  onPointerMove(event, halfScreenWidth, halfScreenHeight),
          child: KeyboardListener(
            focusNode: playgroundFocusNode,
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
                  child: PlaygroundAutoRefreshWrapper(
                    frameWidth: frameWidth,
                    frameHeight: frameHeight,
                    theme: theme,
                    frame: frame,
                    playerOffsetx: playerOffsetx,
                    playerOffsety: playerOffsety,
                    frameOffsetx: frameOffsetx,
                    frameOffsety: frameOffsety,
                  ),
                ),
              ),
            ),
          ),
        );
      }),
    );
  }
}
