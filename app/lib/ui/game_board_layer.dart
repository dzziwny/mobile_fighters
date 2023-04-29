import 'package:bubble_fight/di.dart';
import 'package:bubble_fight/statics.dart';
import 'package:bubble_fight/ui/bubble_game.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';

class GameBoardLayer extends StatelessWidget {
  const GameBoardLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final halfWidth = mediaQuery.size.width / 2;
    final halfHeight = mediaQuery.size.height / 2;
    return Positioned.fill(
      child: Listener(
        onPointerDown: (_) {
          attackWs.send(AttackRequest.startGun);
        },
        onPointerUp: (_) {
          attackWs.send(AttackRequest.stopGun);
        },
        onPointerHover: (event) {
          if (!controlsBloc.gameBoardFocusNode.hasFocus) {
            return;
          }

          final x = event.position.dx - halfWidth;
          final y = event.position.dy - halfHeight;
          final angle =
              (Vector2(x, y).clone()..y *= -1).angleToSigned(Vector2(0.0, 1.0));
          rotateWs.send(PlayerAngle.toBytes(angle));
        },
        child: KeyboardListener(
          focusNode: controlsBloc.gameBoardFocusNode,
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
              width: borderWidth,
              height: borderHeight,
              child: FutureBuilder<GameFrame>(
                  future: serverClient.gameFrame,
                  builder: (context, snapshot) {
                    final frame = snapshot.data;
                    if (frame == null) {
                      return const SizedBox.shrink();
                    }

                    double frameWidth =
                        frame.sizex + borderHorizontalPadding * 2;
                    double frameHeight =
                        frame.sizey + borderVerticalPadding * 2;
                    return StreamBuilder<PlayerPosition>(
                        stream: positionBloc.myPosition$(),
                        builder: (context, snapshot) {
                          final position = snapshot.data;
                          double x = 0.0;
                          double y = 0.0;

                          if (position != null) {
                            x = (position.x - frame.sizex / 2) /
                                ((frameWidth - borderWidth) / 2);
                            y = (position.y - frame.sizey / 2) /
                                ((frameHeight - borderHeight) / 2);
                          }

                          return ClipRect(
                            child: OverflowBox(
                              maxWidth: double.infinity,
                              maxHeight: double.infinity,
                              alignment: Alignment(x, y),
                              child: SizedBox(
                                width: frameWidth,
                                height: frameHeight,
                                child: BubbleGame(
                                  boardWidth: frame.sizex,
                                  boardHeight: frame.sizey,
                                ),
                              ),
                            ),
                          );
                        });
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
