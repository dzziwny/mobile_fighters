import 'package:flutter/material.dart';

class LinesLayer extends StatelessWidget {
  const LinesLayer({super.key});

  @override
  Widget build(BuildContext context) {
    const color = Colors.grey;
    return MouseRegion(
      opaque: false,
      child: Stack(
        children: [
          Row(
            children: [
              const Spacer(),
              Container(color: color, width: 1.0),
              const Spacer(),
            ],
          ),
          Column(
            children: [
              const Spacer(),
              Container(color: color, height: 1.0),
              const Spacer(),
            ],
          ),
        ],
      ),
    );
  }
}
