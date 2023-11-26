import 'package:core/core.dart';
import 'package:flutter/material.dart';

class RespawnsLayer extends StatelessWidget {
  const RespawnsLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final respWidth = respawnWidth.toDouble();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: respWidth,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                spreadRadius: respWidth,
                blurRadius: respWidth,
                color: Colors.blue.withOpacity(0.6),
              )
            ],
          ),
        ),
        Container(
          width: respWidth,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                spreadRadius: respWidth,
                blurRadius: respWidth,
                color: Colors.red.withOpacity(0.6),
              )
            ],
          ),
        ),
      ],
    );
  }
}
