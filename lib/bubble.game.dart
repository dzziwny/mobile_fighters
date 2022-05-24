import 'package:bubble_fight/player.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BubbleGame extends FlameGame with HasDraggables {
  final knobPaint = BasicPalette.blue.withAlpha(200).paint();
  final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
  late final joystick = JoystickComponent(
    knob: CircleComponent(radius: 15, paint: knobPaint),
    background: CircleComponent(radius: 50, paint: backgroundPaint),
    margin: const EdgeInsets.only(left: 60, bottom: 60),
  );

  final playerController = PlayerController();
  late final Player player;

  double maxSpeed = 300.0;

  @override
  Future<void> onLoad() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
    ]);
    await super.onLoad();

    player = await Player.create(playerController);
    add(player);
    add(joystick);
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (!joystick.delta.isZero()) {
      player.position.add(joystick.relativeDelta * maxSpeed * dt);
      player.angle = joystick.delta.screenAngle();
    }
  }
}
