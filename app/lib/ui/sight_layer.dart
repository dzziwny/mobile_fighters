import 'package:flutter/material.dart';

class SightLayer extends StatefulWidget {
  const SightLayer({super.key});

  @override
  State<SightLayer> createState() => _SightLayerState();
}

class _SightLayerState extends State<SightLayer> {
  var top = 0.0;
  var left = 0.0;

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: MouseRegion(
        opaque: false,
        cursor: SystemMouseCursors.none,
        onHover: (event) {
          final x = event.position.dx;
          final y = event.position.dy;
          setState(() {
            top = y;
            left = x;
          });
        },
        child: Stack(
          children: [
            Positioned(
              top: top - 19.0,
              left: left - 19.0,
              child: Image.asset('assets/sight.png'),
            ),
          ],
        ),
      ),
    );
  }
}
