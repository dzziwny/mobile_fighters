import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class PlayerController {}

class Player extends RiveComponent {
  final PlayerController controller;
  final String nick;

  Player({
    required super.artboard,
    required this.controller,
    required this.nick,
  });

  static Future<Player> create(String nick) async {
    final artboard = await loadArtboard(
      RiveFile.asset('assets/ball_player.riv'),
    );

    final playerMovementAnimationController = OneShotAnimation(
      'movement',
      autoplay: false,
    );
    artboard.addController(playerMovementAnimationController);
    return Player(
      artboard: artboard,
      controller: PlayerController(),
      nick: nick,
    );
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    size = Vector2.all(50);
    anchor = Anchor.center;
  }

  Future<void> removeBackground() async {
    artboard.forEachComponent((p0) {
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
}
