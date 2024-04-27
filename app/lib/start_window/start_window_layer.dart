import 'package:bubble_fight/game_ui_settings.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'start_window.controller.dart';
import 'start_window.dart';

class StartWindowLayer extends StatefulWidget {
  const StartWindowLayer({
    super.key,
  });

  @override
  State<StartWindowLayer> createState() => _StartWindowLayerState();
}

class _StartWindowLayerState extends State<StartWindowLayer> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: startWindowController.show(),
      builder: (context, snapshot) {
        final show = snapshot.data;
        if (show != true) {
          return const SizedBox.shrink();
        }

        return MouseRegion(
          child: Center(
            child: FittedBox(
              child: SizedBox(
                width: gameSettings.screenWidth,
                height: gameSettings.screenHeight,
                child: Center(
                  child: SizedBox(
                    height: 500.0,
                    child: FittedBox(
                      child: SizedBox(
                        width: 600 * gameUISettings.goldenRatio,
                        height: 600,
                        child: const StartWindow(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
