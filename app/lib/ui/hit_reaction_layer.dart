import 'dart:async';

import 'package:flutter/material.dart';

class HitReactionLayer extends StatefulWidget {
  const HitReactionLayer({
    super.key,
  });

  @override
  State<HitReactionLayer> createState() => _HitReactionState();
}

class _HitReactionState extends State<HitReactionLayer>
    with TickerProviderStateMixin {
  late final AnimationController opacityController;
  late final AnimationController radiusController;
  late final StreamSubscription hitSubscription;

  @override
  void initState() {
    super.initState();
    opacityController = AnimationController(
      value: 0.0,
      vsync: this,
    );

    radiusController = AnimationController(
      value: 10.0,
      vsync: this,
    );

    // TODO
    // hitSubscription = gameDataWs.data().listen((state) {
    //   state.players.
    //   for (var hit in state.hits) {
    //     if (hit.playerId == id) {
    //       animateHit();
    //     }
    //   }
    // });
  }

  Future<void> animateHit() async {
    await Future.wait([
      opacityController.animateTo(
        1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeIn,
      ),
      radiusController.animateTo(
        0.9,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeIn,
      )
    ]);

    await Future.wait([
      opacityController.animateTo(
        0.0,
        duration: const Duration(milliseconds: 1800),
        curve: Curves.easeIn,
      ),
      radiusController.animateTo(
        2.0,
        duration: const Duration(milliseconds: 1800),
        curve: Curves.easeIn,
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      opaque: false,
      child: AnimatedBuilder(
          animation: opacityController,
          builder: (_, __) {
            return Opacity(
              opacity: opacityController.value,
              child: AnimatedBuilder(
                  animation: radiusController,
                  builder: (_, __) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          radius: radiusController.value,
                          colors: [
                            Colors.transparent,
                            theme.colorScheme.error,
                          ],
                        ),
                      ),
                    );
                  }),
            );
          }),
    );
  }

  @override
  Future<void> dispose() async {
    opacityController.dispose();
    radiusController.dispose();
    await hitSubscription.cancel();
    super.dispose();
  }
}
