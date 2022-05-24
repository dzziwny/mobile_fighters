import 'dart:async';

import 'package:bubble_fight/joystic.component.dart';
import 'package:bubble_fight/server/firebase.server.dart';
import 'package:bubble_fight/server/local.server.dart';
import 'package:bubble_fight/player.dart';
import 'package:bubble_fight/server/server.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:uuid/uuid.dart';

class BubbleGame extends FlameGame with HasDraggables {
  BubbleGame({
    required this.gameId,
  });

  final String gameId;
  final players = <String, Player>{};
  // final myId = const Uuid().v4();
  final myId = '59df6c4f-de56-43c5-a006-94071f79ac65';
  final nick = 'dzziwny';
  final Server server = LocalServer();
  // late Server server = FirebaseServer(gameId: gameId);

  late StreamSubscription<void> onChildAddedSub;
  late StreamSubscription<void> onPlayerRemovedSub;
  final playersPositionsSubs = <String, StreamSubscription<void>>{};

  double maxSpeed = 300.0;

  @override
  Future<void> onLoad() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitDown,
    ]);
    await super.onLoad();
    await initializeJoystic();
    await initializeMyPlayer();

    watchPlayers();
  }

  Future<void> initializeJoystic() async {
    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    final joystick = MyJoysticComponent(
        knob: CircleComponent(radius: 15, paint: knobPaint),
        background: CircleComponent(radius: 50, paint: backgroundPaint),
        margin: const EdgeInsets.only(left: 60, bottom: 60),
        updateFunc: (dt, relativeDelta, delta) {
          if (!delta.isZero()) {
            final value = relativeDelta * maxSpeed * dt;
            final angle = delta.screenAngle();
            server.updatePosition(myId, value, angle);
          }
        });

    add(joystick);
  }

  Future<void> initializeMyPlayer() async {
    await server.createPlayer(myId, nick);
  }

  void watchPlayers() {
    onChildAddedSub = server.onPlayerAdded$().map((event) {
      addPlayerToGame(event);
      watchPlayerUpdate(event);
    }).listen(null);

    onPlayerRemovedSub = server
        .onPlayerRemoved$()
        .map((event) => removePlayer(event))
        .listen(null);
  }

  void addPlayerToGame(DatabaseEvent event) async {
    debugPrint(
      '[Adding player] key: ${event.snapshot.key}, nick: ${(event.snapshot.value as dynamic)['nick']}',
    );
    final player = await Player.create();
    players[event.snapshot.key!] = player;
    await add(player);
  }

  void watchPlayerUpdate(DatabaseEvent event) {
    final playerId = event.snapshot.key!;
    debugPrint(
      '[Watching player position] id: $playerId, nick: ${(event.snapshot.value as dynamic)['nick']}',
    );

    final sub = server.onPlayerPositionUpdate$(playerId).map((change) {
      debugPrint(
        '[Player position update] $playerId: ${change.snapshot.value}',
      );

      players[myId]!.position.add(Vector2(
          (change.snapshot.value as dynamic)['x'],
          (change.snapshot.value as dynamic)['y']));
      players[myId]!.angle = (change.snapshot.value as dynamic)['angle'];
    }).listen(null);

    playersPositionsSubs[playerId] = sub;
  }

  void removePlayer(dynamic event) async {
    debugPrint(
      '[Removing player] key: ${event.snapshot.key}, nick: ${(event.snapshot.value as dynamic)['nick']}',
    );
    final playerId = event.snapshot.key!;
    final player = players[playerId];
    remove(player!);
    players.remove(playerId);
    await playersPositionsSubs[playerId]?.cancel();
    playersPositionsSubs.remove(playerId);
  }
}
