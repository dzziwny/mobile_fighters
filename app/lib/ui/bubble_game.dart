import 'package:bubble_fight/statics.dart';
import 'package:bubble_fight/ui/players_layer.dart';
import 'package:flutter/material.dart';

import 'attacks_layer.dart';

class BubbleGame extends StatelessWidget {
  const BubbleGame({
    super.key,
    required this.boardWidth,
    required this.boardHeight,
  });

  final double boardWidth;
  final double boardHeight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
          padding: const EdgeInsets.symmetric(
            vertical: borderVerticalPadding,
            horizontal: borderHorizontalPadding,
          ),
          child: Container(
            width: boardWidth,
            height: boardHeight,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment(0.8, 1),
                colors: <Color>[
                  Color(0xff1f005c),
                  Color(0xff5b0060),
                  Color(0xff870160),
                  Color(0xffac255e),
                  Color(0xffca485c),
                  Color(0xffe16b5c),
                  Color(0xfff39060),
                  Color(0xffffb56b),
                ],
              ),
              image: DecorationImage(
                image: AssetImage('assets/background.jpeg'),
                fit: BoxFit.fitHeight,
              ),
              borderRadius: BorderRadius.all(
                Radius.circular(16.0),
              ),
            ),
            child: Stack(
              children: const [
                AttacksLayer(),
                PlayersLayer(),
              ],
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.only(left: 10.0, right: 15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Tablet frame home button
              Container(
                height: 20.0,
                width: 20.0,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                ),
              ),
              // Tablet frame camera
              Container(
                height: 10.0,
                width: 10.0,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                ),
                alignment: Alignment.center,
                child: Container(
                  height: 5.0,
                  width: 5.0,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade900,
                    borderRadius: const BorderRadius.all(Radius.circular(2.5)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
