import 'dart:math';

import 'package:bubble_fight/di.dart';
import 'package:flutter/material.dart';

class AttacksLayer extends StatelessWidget {
  const AttacksLayer({super.key});

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
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInBack,
                builder: (context, value, child) {
                  return Positioned(
                    top: attack.startY + value * changeY,
                    left: attack.startX + value * changeX,
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
