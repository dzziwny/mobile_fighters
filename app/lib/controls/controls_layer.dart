import 'package:bubble_fight/config.dart';
import 'package:flutter/material.dart';

import 'joystic.dart';
import 'keyboard.dart';

class ControlsLayer extends StatelessWidget {
  const ControlsLayer({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 32.0,
      left: 32.0,
      child: Opacity(
        opacity: 0.8,
        child: isMobile ? const Joystic() : const Keyboard(),
      ),
    );
  }
}
