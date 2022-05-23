import 'package:bubble_fight/player.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';
import 'package:flutter/services.dart';

class BubbleGame extends FlameGame with HasDraggables {
  final knobPaint = BasicPalette.blue.withAlpha(200).paint();
  final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
  late final joystick = JoystickComponent(
    knob: CircleComponent(radius: 15, paint: knobPaint),
    background: CircleComponent(radius: 50, paint: backgroundPaint),
    margin: const EdgeInsets.only(left: 60, bottom: 60),
  );

  // late final Player player;
  // late final Player player = Player()
  //   ..position = size / 2
  //   ..width = 50
  //   ..height = 100
  //   ..anchor = Anchor.center;

  double maxSpeed = 300.0;

  late RiveComponent playerComponent;
  final playerMovementAnimationController = OneShotAnimation(
    'movement',
    autoplay: false,
  );

  late final _playerArtboard =
      loadArtboard(RiveFile.asset('assets/ball_player.riv'));

  @override
  Future<void> onLoad() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
    ]);
    await super.onLoad();
    removeBackground();
    final playerArtboard = await _playerArtboard;
    playerComponent = RiveComponent(artboard: playerArtboard)
      ..size = Vector2.all(100)
      ..anchor = Anchor.center;
    // var playerController = OneShotAnimation('idle', autoplay: true);
    playerArtboard.addController(playerMovementAnimationController);
    add(playerComponent);
    add(joystick);
  }

  Future<void> removeBackground() async {
    final playerArtboard = await _playerArtboard;
    playerArtboard.forEachComponent((p0) {
      if (p0 is Fill) {
        final isBackground = p0.paint.color.value == 0xff977bc3;
        if (isBackground) {
          p0.paint.color = Colors.transparent;
        }
      }

      if (p0 is Stroke) {
        final isShadow = p0.paint.color.value == 0xff844da3;
        if (isShadow) {
          p0.paint.color = Colors.transparent;
        }
      }

      if (p0 is Shape) {
        final isShadow = p0.name == 'shadow';
        if (isShadow && p0.fills.isNotEmpty) {
          p0.fills.first.paint.color = Colors.transparent;
        }
      }
    });
  }

  @override
  void update(double dt) {
    super.update(dt);
    // if (!joystick.delta.isZero() && activeCollisions.isEmpty) {
    if (!joystick.delta.isZero()) {
      // _lastSize.setFrom(size);
      // _lastTransform.setFrom(transform);
      playerComponent.position.add(joystick.relativeDelta * maxSpeed * dt);
      playerComponent.angle = joystick.delta.screenAngle();
      // playerMovementAnimationController.isActive = true;
    } else {
      // print('reset');
      playerMovementAnimationController.reset();
    }
  }
}
