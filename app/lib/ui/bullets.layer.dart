import 'package:bubble_fight/di.dart';
import 'package:flutter/material.dart';

class BulletsLayer extends StatelessWidget {
  const BulletsLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: bulletBloc.bullets,
      builder: (context, value, child) {
        return Stack(
          children: value.entries.map(
            (entry) {
              return Positioned(
                key: ValueKey(entry.value.id),
                top: entry.value.y - 15.0,
                left: entry.value.x - 15.0,
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
