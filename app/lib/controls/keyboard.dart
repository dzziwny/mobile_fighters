import 'package:flutter/material.dart';

class Keyboard extends StatelessWidget {
  const Keyboard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _KeyboardButton('w'),
        SizedBox(height: 6.0),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _KeyboardButton('a'),
            SizedBox(width: 6.0),
            _KeyboardButton('s'),
            SizedBox(width: 6.0),
            _KeyboardButton('d'),
          ],
        ),
      ],
    );
  }
}

class _KeyboardButton extends StatelessWidget {
  const _KeyboardButton(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        borderRadius: BorderRadius.circular(6.0),
        color: Colors.white.withOpacity(0.2),
      ),
      width: 50.0,
      height: 50.0,
      child: Container(
        alignment: Alignment.topRight,
        margin: const EdgeInsets.only(right: 4.0),
        child: Text(
          text,
          style: TextStyle(color: Colors.white.withOpacity(0.6)),
        ),
      ),
    );
  }
}
