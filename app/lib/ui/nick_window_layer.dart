import 'package:bubble_fight/di.dart';
import 'package:bubble_fight/statics.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';

import 'nick_window.dart';

class NickWindowLayer extends StatelessWidget {
  const NickWindowLayer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: serverClient.isInGame(),
      builder: (context, snapshot) {
        final isInGame = snapshot.data;
        if (isInGame == true) {
          return const SizedBox.shrink();
        }

        return const MouseRegion(
          child: Center(
            child: FittedBox(
              child: SizedBox(
                width: borderWidth,
                height: borderHeight,
                child: Center(
                  child: SizedBox(
                    height: 500.0,
                    child: FittedBox(
                      child: SizedBox(
                        width: 600 * goldenRatio,
                        height: 600,
                        child: NickWindow(),
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
