import 'package:bubble_fight/di.dart';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_shake_animated/flutter_shake_animated.dart'
    as flutter_shake_animated;

import 'shake_extended_widget.dart';

class AttacksBottomLayer extends StatelessWidget {
  const AttacksBottomLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return StreamBuilder(
      stream: attackBloc.attacks$(),
      builder: (context, snapshot) {
        final attacks = snapshot.data;
        if (attacks == null) {
          return const SizedBox.shrink();
        }

        return Stack(
          children: attacks.map(
            (attack) {
              return TweenAnimationBuilder(
                key: ValueKey(attack.id),
                tween: Tween(begin: 0.0, end: 1.0),
                duration: attackUntilBoomDuration,
                curve: Curves.linear,
                builder: (context, value, child) {
                  return Positioned(
                    top: attack.targetY - attackAreaDiameter / 2,
                    left: attack.targetX - attackAreaDiameter / 2,
                    child: SizedBox(
                      width: attackAreaDiameter,
                      height: attackAreaDiameter,
                      child: FittedBox(
                        child: ShakeWidget(
                          power: value,
                          duration: const Duration(milliseconds: 500),
                          shakeConstant: AttackShakeConstant(),
                          autoPlay: true,
                          child: Card(
                            shape: const CircleBorder(),
                            color: Color.alphaBlend(
                              theme.colorScheme.error.withOpacity(value),
                              theme.cardTheme.color ??
                                  theme.colorScheme.surface,
                            ),
                            child: const SizedBox(
                              height: attackAreaDiameter,
                              width: attackAreaDiameter,
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ).toList(),
        );
      },
    );
  }
}

class AttackShakeConstant implements flutter_shake_animated.ShakeConstant {
  @override
  List<int> get interval => [10];

  @override
  List<double> get opacity =>
      [1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0];

  @override
  List<double> get rotate => [0, -7, 5, 9, -1, -1, -8, 5, 9, -9, 0];

  @override
  List<Offset> get translate => const [
        Offset.zero,
        Offset(10, 3),
        Offset(-8, -8),
        Offset(4, -10),
        Offset(1, -2),
        Offset(19, -6),
        Offset(-10, 20),
        Offset(-11, -18),
        Offset(14, 7),
        Offset(-3, 9),
        Offset.zero
      ];

  @override
  Duration get duration => const Duration(milliseconds: 100);
}
