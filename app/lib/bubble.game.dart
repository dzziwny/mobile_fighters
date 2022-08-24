import 'dart:async';
import 'dart:developer';

import 'package:bubble_fight/joystic.component.dart';
import 'package:bubble_fight/player.dart';
import 'package:bubble_fight/server/server_client.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';

class BubbleGame extends FlameGame with HasDraggables {
  BubbleGame({
    required this.gameId,
  });

  final String gameId;
  final players = <int, Player>{};
  late final int myId;
  final nick = 'dzziwny';
  final ServerClient client = GetIt.I<ServerClient>();

  late StreamSubscription<void> onChildAddedSub;
  late StreamSubscription<void> onPlayerRemovedSub;
  final playersPositionsSubs = <int, StreamSubscription<void>>{};

  @override
  Future<void> onLoad() async {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitDown,
    ]);
    await super.onLoad();
    await initializeJoystic();
    myId = await client.createPlayer(nick);

    watchPlayers();
  }

  Future<void> initializeJoystic() async {
    final knobPaint = BasicPalette.blue.withAlpha(200).paint();
    final backgroundPaint = BasicPalette.blue.withAlpha(100).paint();
    final joystick = MyJoysticComponent(
        knob: CircleComponent(radius: 15, paint: knobPaint),
        background: CircleComponent(radius: 50, paint: backgroundPaint),
        margin: const EdgeInsets.only(left: 60, bottom: 60),
        updateFunc: (angle, delta) {
          client.updateKnob(myId, angle, delta.x, delta.y);
        });

    add(joystick);
  }

  void watchPlayers() {
    onChildAddedSub = client
        .onPlayerAdded$()
        .asyncMap((data) => onPlayerAdded(data))
        .listen(null);

    onPlayerRemovedSub = client
        .onPlayerRemoved$()
        .asyncMap((event) => removePlayer(event))
        .listen(null);
  }

  void addPlayerToGame(List<int> data) async {
    final playerId = data[0];
    final nick = String.fromCharCodes(data.sublist(1));
    final player = await Player.create(nick);
    players[playerId] = player;
    await add(player);
  }

  Future<void> onPlayerAdded(List<int> data) async {
    final playerId = data[0];
    final nick = String.fromCharCodes(data.sublist(1));
    final player = await Player.create(nick);
    players[playerId] = player;
    await add(player);

    final sub = client.onPlayerPositionUpdate$(playerId).map((position) {
      player.position = Vector2(position.x, position.y);
      player.angle = position.angle;
    }).listen(null);

    playersPositionsSubs[playerId] = sub;
  }

  Future<void> removePlayer(List<int> data) async {
    final playerId = data[0];
    final player = players[playerId];
    if (player == null) {
      debugger();
      debugPrint("No player with id '$playerId'  to remove");
      return;
    }

    remove(player);
    players.remove(playerId);
    await playersPositionsSubs[playerId]?.cancel();
    playersPositionsSubs.remove(playerId);
  }
}
