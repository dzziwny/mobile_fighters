import 'dart:async';
import 'dart:developer';

import 'package:bubble_fight/joystic.component.dart';
import 'package:bubble_fight/player.dart';
import 'package:bubble_fight/server_client.dart';
import 'package:core/core.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

class BubbleGame extends FlameGame with HasDraggables {
  late final StreamSubscription positionsSubscription;
  late final StreamSubscription changePlayersSubscription;

  BubbleGame({
    required this.gameId,
  }) {
    positionsSubscription = client.position$().map((Position position) {
      final player = players[position.playerId];
      if (player == null) {
        return;
      }

      player.position = Vector2(position.x, position.y);
      player.setAngle(position.angle);
    }).listen(null);

    changePlayersSubscription = client.playerChange$().map((dto) {
      switch (dto.type) {
        case PlayerChangeType.added:
          final nick = dto.nick;
          final player = PlayerComponent(nick: nick);
          players[dto.id] = player;
          add(player);
          break;
        case PlayerChangeType.removed:
          final player = players.remove(dto.id);
          if (player != null) {
            remove(player);
          }
          break;
        default:
          throw 'Unknown PlayerChangeType';
      }
    }).listen(null);
  }

  @override
  Color backgroundColor() => Colors.blue;

  final String gameId;
  final players = <int, PlayerComponent>{};
  final nick = 'dzziwny';
  final ServerClient client = GetIt.I<ServerClient>();

  @override
  Future<void> onLoad() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitDown,
    ]);

    final paint = const PaletteEntry(Color.fromRGBO(160, 196, 255, 1)).paint()
      ..style = PaintingStyle.fill;
    final rectangle = RectangleComponent(
      size: Vector2(750.0, 550.0),
      position: Vector2(400.0, 300.0),
      paint: paint,
      anchor: Anchor.center,
    );
    add(rectangle);
    await super.onLoad();
    await initializeJoystic();
  }

  Future<void> initializeJoystic() async {
    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    final joystick = MyJoysticComponent(
        knob: CircleComponent(radius: 15, paint: knobPaint),
        background: CircleComponent(radius: 50, paint: backgroundPaint),
        margin: const EdgeInsets.only(left: 60, bottom: 60),
        updateFunc: (angle, delta) {
          client.updateKnob(angle, delta.x, delta.y);
        });

    add(joystick);
  }
}
