import 'package:flame/components.dart';
import 'package:flame_rive/flame_rive.dart';
import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class Player extends PositionComponent {
  static final _paint = Paint()..color = Colors.white;

  final Artboard _artboard;

  Player._(this._artboard);

  static Future<Player> create() async {
    final artboard = await loadArtboard(RiveFile.asset('assets/player.riv'));
    return Player._(artboard);
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // _artboard.addComponent(this);
    canvas.drawCircle(Offset.zero, 20.0, _paint);
  }
}
