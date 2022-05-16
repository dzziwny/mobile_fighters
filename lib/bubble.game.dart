import 'package:bubble_fight/player.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class BubbleGame extends FlameGame with HasDraggables {
  final knobPaint = BasicPalette.blue.withAlpha(200).paint();
  final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
  late final joystick = JoystickComponent(
    knob: CircleComponent(radius: 30, paint: knobPaint),
    background: CircleComponent(radius: 100, paint: backgroundPaint),
    margin: const EdgeInsets.only(left: 40, bottom: 40),
  );

  // late final Player player;
  // late final Player player = Player()
  //   ..position = size / 2
  //   ..width = 50
  //   ..height = 100
  //   ..anchor = Anchor.center;

  double maxSpeed = 300.0;

  late RiveComponent playerComponent;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    final playerArtboard =
        await loadArtboard(RiveFile.asset('assets/player.riv'));
    // playerArtboard.forEachComponent((p0) {
    //   print(p0.name);
    //   if (p0.name.contains('Root')) {
    //     Fill fill = p0 as Fill;
    //     fill.paint.color = Colors.transparent;
    //   }
    // });
    playerComponent = RiveComponent(artboard: playerArtboard);
    playerComponent.size = Vector2.all(300);
    var playerController = OneShotAnimation('idle', autoplay: true);
    playerArtboard.addController(playerController);
    add(playerComponent);

    // player = await Player.create();
    // add(player);
    add(joystick);
  }

  @override
  void update(double dt) {
    super.update(dt);
    // if (!joystick.delta.isZero() && activeCollisions.isEmpty) {
    if (!joystick.delta.isZero()) {
      // _lastSize.setFrom(size);
      // _lastTransform.setFrom(transform);
      // player.position.add(joystick.relativeDelta * maxSpeed * dt);
      // angle = joystick.delta.screenAngle();
    }
  }
}
