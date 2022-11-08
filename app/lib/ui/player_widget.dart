import 'package:core/core.dart';
import 'package:flutter/material.dart';

class PlayerWidget extends StatelessWidget {
  final Player player;
  const PlayerWidget({
    required this.player,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 30.0,
      width: 30.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 10.0,
            width: 10.0,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
