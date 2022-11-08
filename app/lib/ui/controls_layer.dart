import 'package:flutter/material.dart';

import 'joystic.dart';

class ControlsLayer extends StatelessWidget {
  const ControlsLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return const Positioned(
      bottom: 70.0,
      left: 70.0,
      child: Opacity(
        opacity: 0.8,
        child: Joystic(),
      ),
    );
  }
}
