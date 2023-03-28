import 'package:core/core.dart';
import 'package:flutter/material.dart';

class RespawnsLayer extends StatelessWidget {
  const RespawnsLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: respawnWidth,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                spreadRadius: respawnWidth,
                blurRadius: respawnWidth,
                color: Colors.blue.withOpacity(0.6),
              )
            ],
          ),
        ),
        Container(
          width: respawnWidth,
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                spreadRadius: respawnWidth,
                blurRadius: respawnWidth,
                color: Colors.red.withOpacity(0.6),
              )
            ],
          ),
        ),
      ],
    );
  }
}
