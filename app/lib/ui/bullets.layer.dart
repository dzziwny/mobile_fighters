import 'package:bubble_fight/di.dart';
import 'package:flutter/material.dart';

class BulletsLayer extends StatelessWidget {
  const BulletsLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: bulletWs.data(),
      builder: (context, snapshot) {
        final bullets = snapshot.data ?? [];
        return Stack(
          children: bullets.map(
            (bullet) {
              return Positioned(
                key: ValueKey(bullet.id),
                top: bullet.y - 15.0,
                left: bullet.x - 15.0,
                height: 30.0,
                width: 30.0,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(15.0),
                  ),
                ),
              );
            },
          ).toList(),
        );
      },
    );
  }
}
