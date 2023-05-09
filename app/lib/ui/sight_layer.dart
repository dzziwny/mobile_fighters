import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as mat;
import 'package:vector_math/vector_math.dart';

class SightLayer extends StatefulWidget {
  const SightLayer({super.key});

  @override
  State<SightLayer> createState() => _SightLayerState();
}

class _SightLayerState extends State<SightLayer> {
  final position = ValueNotifier(Vector2(0.0, 0.0));

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      opaque: false,
      cursor: SystemMouseCursors.none,
      child: Listener(
        onPointerMove: (e) {
          position.value = Vector2(e.position.dx, e.position.dy);
        },
        onPointerHover: (e) {
          position.value = Vector2(e.position.dx, e.position.dy);
        },
        // Container must be so that listener can catch whole area not only a sight
        child: Container(
          color: mat.Colors.transparent,
          child: Stack(
            children: [
              ValueListenableBuilder(
                valueListenable: position,
                builder: (context, value, child) {
                  return Positioned(
                    top: value.y - 19.0,
                    left: value.x - 19.0,
                    child: Image.asset('assets/sight.png'),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
