import 'dart:async';

import 'package:bubble_fight/joystic.component.dart';
import 'package:bubble_fight/player.dart';
import 'package:bubble_fight/server_client.dart';
import 'package:core/core.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

class BubbleFlameGame extends FlameGame
    with HasDraggables, KeyboardEvents, TapDetector {
  final String gameId;
  final players = <int, PlayerComponent>{};
  final ServerClient client = GetIt.I<ServerClient>();

  late final StreamSubscription positionsSubscription;
  late final StreamSubscription changePlayersSubscription;
  late final StreamSubscription attackSubscription;
  late final StreamSubscription hitSubscription;

  bool isAttacking = false;
  bool isAttackCooldown = false;
  bool isDashCooldown = false;

  BubbleFlameGame({
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
          if (players[dto.id] != null) {
            return;
          }
          final player = PlayerComponent(nick: dto.nick, team: dto.team);
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

    attackSubscription = client.attack$().map((position) {
      final player = players[position.playerId];
      if (player == null) {
        return;
      }

      player.attack();
    }).listen(null);

    hitSubscription = client.hit$().map((dto) {
      final player = players[dto.playerId];
      if (player == null) {
        return;
      }

      player.setHp(dto.hp);
    }).listen(null);

    client.dead$.map((id) {
      final player = players[id];
      final context = buildContext;
      if (player == null || context == null) {
        return;
      }

      showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('You have been killed by ${player.nick}.'),
            actions: <Widget>[
              TextButton(
                child: const Text('Back to the game.'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }).listen(null);
  }

  @override
  Color backgroundColor() => Colors.blue;

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    await Future.wait([
      initializeBoard()
          .then((_) => initializePlayers())
          .then((_) => initializeJoystic()),
    ]);
  }

  @override
  void onAttach() {
    super.onAttach();
    // Focus on game, so that keyboard evens could work
    client.isInGame().where((event) => event).first.then((_) {
      final game = findGame();
      if (game == null) {
        return;
      }
      final context = game.buildContext;
      if (context != null) {
        Focus.of(context).requestFocus();
      }
    });
  }

  @override
  KeyEventResult onKeyEvent(
    RawKeyEvent event,
    Set<LogicalKeyboardKey> keysPressed,
  ) {
    final isKeyDown = event is RawKeyDownEvent;
    if (!isKeyDown) {
      return KeyEventResult.ignored;
    }

    final isAttackKey = event.character == 'e';
    if (isAttackKey) {
      client.attack();
      return KeyEventResult.handled;
    }

    final isSpace = keysPressed.contains(LogicalKeyboardKey.space);
    if (isSpace && isKeyDown) {
      client.dash();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  bool onTapDown(TapDownInfo info) {
    final position = info.eventPosition.game;
    // final component = PlayerComponent(nick: 'hit')..position = position;
    // add(component);
    return true;
  }

  Future<void> initializeBoard() async {
    final paint = const PaletteEntry(Color.fromRGBO(160, 196, 255, 1)).paint()
      ..style = PaintingStyle.fill;

    final frame = await client.gameFrame();
    final board = RectangleComponent(
      size: Vector2(frame.sizex, frame.sizey),
      position: Vector2(frame.positionx, frame.positiony),
      paint: paint,
      anchor: Anchor.center,
    );

    await add(board);
  }

  Future<void> initializePlayers() async {
    final players = await getPlayers$();
    for (final player in players) {
      if (this.players[player.id] != null) {
        return;
      }

      final component = PlayerComponent(nick: player.nick, team: player.team);
      this.players[player.id] = component;
      add(component);
    }
  }

  Future<void> initializeJoystic() async {
    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    final joystick = MyJoysticComponent(
        knob: CircleComponent(radius: 15, paint: knobPaint),
        background: CircleComponent(radius: 50, paint: backgroundPaint),
        margin: const EdgeInsets.only(left: 60, bottom: 60),
        updateFunc: (angle, delta) {
          client.updatePosition(angle, delta.x, delta.y);
        });

    add(joystick);
  }
}
