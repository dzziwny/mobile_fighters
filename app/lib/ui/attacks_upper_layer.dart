import 'dart:math';

import 'package:bubble_fight/di.dart';
import 'package:flutter/material.dart';

class AttacksUpperLayer extends StatelessWidget {
  const AttacksUpperLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: serverClient.attacks$(),
      builder: (context, snapshot) {
        final attacks = snapshot.data;
        if (attacks == null) {
          return const SizedBox.shrink();
        }

        return Stack(
          children: attacks.map(
            (attack) {
              final changeX = attack.targetX - attack.startX;
              final changeY = attack.targetY - attack.startY;
              return TweenAnimationBuilder(
                key: ValueKey(attack.id),
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 1000),
                curve: Curves.easeOutExpo,
                builder: (context, value, child) {
                  const attackSize = 100.0;
                  const attackSizeHalf = attackSize / 2;
                  final startY = attack.startY - attackSizeHalf;
                  final startX = attack.startX - attackSizeHalf;
                  return Positioned(
                    top: startY + value * changeY,
                    left: startX + value * changeX,
                    child: SizedBox(
                      height: attackSize,
                      width: attackSize,
                      child: Center(
                        child: Transform.scale(
                          scale: 1.0 - value,
                          child: Transform.rotate(
                            angle: 2 * pi * value,
                            // child: BottomNavigationBar(
                            //   type: BottomNavigationBarType.fixed,
                            //   items: const [
                            //     BottomNavigationBarItem(
                            //       icon: Icon(Icons.mail),
                            //       label: 'Mail',
                            //     ),
                            //     BottomNavigationBarItem(
                            //       icon: Icon(Icons.chat_bubble_outline),
                            //       label: 'Chat',
                            //     ),
                            //     BottomNavigationBarItem(
                            //       icon: Icon(Icons.people_outline),
                            //       label: 'Rooms',
                            //     ),
                            //     BottomNavigationBarItem(
                            //       icon: Icon(Icons.videocam_outlined),
                            //       label: 'Meet',
                            //     ),
                            //   ],
                            // ),
                            child: FilledButton(
                              onPressed: () {},
                              child: const Text('Siema!'),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
                onEnd: () => attacks.remove(attack),
              );
            },
          ).toList(),
        );
      },
    );
  }
}
