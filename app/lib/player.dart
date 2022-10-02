import 'dart:async' as async;
import 'dart:math';

import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class PlayerController {}

class PlayerComponent extends PositionComponent {
  final String nick;
  late final Future<PlayerRiveComponent> rivePlayer;
  late final Future<HpIndicatorComponent> hpIndicator;
  final paint = TextPaint(
    style: const TextStyle(
      fontSize: 20.0,
      fontFamily: 'Awesome Font',
      color: Colors.white,
    ),
  );

  double _angle = 0.0;

  PlayerComponent({
    required this.nick,
  }) {
    rivePlayer = PlayerRiveComponent.create(nick);
    hpIndicator = HpIndicatorComponent.create();
  }

  @override
  Future<void> onLoad() async {
    final player = await rivePlayer
      ..anchor = Anchor.center
      ..size = Vector2.all(50);

    await add(player);
    await add(
      (await hpIndicator)
        ..position = Vector2(0.0, 5.0)
        ..size = Vector2.all(361.5 / 3.5)
        ..anchor = Anchor.bottomCenter,
    );
  }

  @override
  void render(Canvas canvas) {
    if (kDebugMode) {
      paint.render(
        canvas,
        '[x: ${position.x.ceilToDouble()}, y: ${position.y.ceilToDouble()}, a: ${double.parse((_angle).toStringAsFixed(2))}]',
        Vector2(0.0, -90.0),
        anchor: Anchor.bottomCenter,
      );
    }
    paint.render(
      canvas,
      nick,
      Vector2(0.0, -65.0),
      anchor: Anchor.bottomCenter,
    );

    if (isAttacking) {
      _drawAttack(canvas);
    }
  }

  bool isAttacking = false;
  void _drawAttack(Canvas canvas) {
    var area = Path();
    const center = Point(0.0, 0.0);
    area.moveTo(center.x, center.y);
    const r = 150.0;
    const dAngle = pi / 6;
    final dx1 = r * sin(_angle - dAngle);
    final dy1 = r * cos(_angle - dAngle);
    final x1 = center.x + dx1;
    final y1 = center.y - dy1;
    area.lineTo(x1, y1);

    final dx2 = r * sin(_angle + dAngle);
    final dy2 = r * cos(_angle + dAngle);
    final x2 = center.x + dx2;
    final y2 = center.y - dy2;
    area.lineTo(x2, y2);

    area.close();
    canvas.drawPath(
      area,
      Paint()
        ..color = Colors.green
        ..style = PaintingStyle.fill,
    );
  }

  Future<void> setAngle(double angle) async {
    _angle = angle;
    (await rivePlayer).angle = angle;
  }

  Future<void> setHp(int value) async {
    (await hpIndicator).set(value.toDouble());
  }

  async.Timer? attackTimer;

  void attack() {
    isAttacking = true;
    attackTimer?.cancel();
    attackTimer = async.Timer(
      const Duration(milliseconds: 200),
      () {
        isAttacking = false;
      },
    );
  }
}

class PlayerRiveComponent extends RiveComponent {
  final PlayerController controller;
  final String nick;

  PlayerRiveComponent({
    required super.artboard,
    required this.controller,
    required this.nick,
  });

  static Future<PlayerRiveComponent> create(String nick) async {
    final artboard = await loadArtboard(
      RiveFile.asset('assets/ball_player.riv'),
    );

    final playerMovementAnimationController = OneShotAnimation(
      'movement',
      autoplay: false,
    );
    artboard.addController(playerMovementAnimationController);

    return PlayerRiveComponent(
      artboard: artboard,
      controller: PlayerController(),
      nick: nick,
    );
  }
}

class HpIndicatorComponent extends RiveComponent {
  final SMIInput<double> energyInput;

  HpIndicatorComponent({
    required super.artboard,
    required this.energyInput,
  });

  static Future<HpIndicatorComponent> create() async {
    final artboard = await loadArtboard(
      RiveFile.asset('assets/hp_indicator.riv'),
    );

    var controller =
        StateMachineController.fromArtboard(artboard, 'State Machine ');
    if (controller == null) {
      throw Exception(
          'Cannot find state machine controler in hp indicator artboard.');
    }

    final energyInput = controller.findInput<double>('Energy');
    if (energyInput == null) {
      throw Exception('Cannot find energy input in hp indicator artboard.');
    }

    artboard.addController(controller);

    return HpIndicatorComponent(
      artboard: artboard,
      energyInput: energyInput,
    );
  }

  set(double value) => energyInput.change(value);
}
