import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:vector_math/vector_math.dart';

import 'actions/bomb_actions.dart';
import 'bullet.physic.dart';
import 'handler/_handler.dart';
import 'handler/game_data.connection.dart';
import 'handler/mobile_controls.connection.dart';
import 'handler/on_connection.dart';
import 'inputs/player_state_input.dart';
import 'register_di.dart';
import 'setup.dart';
import 'updates/_updates.dart';

int lastUpdateTime = DateTime.now().microsecondsSinceEpoch;
int accumulatorTime = 0;

extension WithWeb on Router {
  void ws(Socket endpoint, OnConnection onConnection) =>
      get(endpoint.route(), onConnection.handler());
}

void main(List<String> args) async {
  // final ip = InternetAddress.anyIPv4;
  final ip = '0.0.0.0';

  final router = Router()
    ..get(Endpoint.gameFrame, gameFrameHandler)
    ..post(Endpoint.connect, connectHandler)
    ..post(Endpoint.startGame, createPlayerHandler)
    ..post(Endpoint.leaveGame, leaveGameHandler)
    ..post(Endpoint.setGamePhysics, setGamePhysicsHandler)
    ..ws(Socket.mobilePlayerStateWs, MobileControlsConnection())
    ..ws(Socket.desktopPlayerStateWs, DesktopControlsConnection())
    ..ws(Socket.gameDataWs, GameDataConnection())
    ..ws(Socket.gameStateWs, GameStateConnection())
    ..ws(Socket.actionsWs, ActionsConnection());

  final handler = Pipeline()
      // .addMiddleware(
      //   logRequests(),
      // )
      .addMiddleware(corsHeaders())
      .addHandler(router);

  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final server = await serve(handler, ip, port);
  print('Server listening on ${server.address.host}:${server.port}');

  // Set the desired frame rate (e.g., 60 frames per second)
  final frameRate = Duration(milliseconds: 1000 ~/ 60);

  Timer.periodic(frameRate, (_) {
    final now = DateTime.now().microsecondsSinceEpoch;
    final dt = now - lastUpdateTime;
    lastUpdateTime = now;
    accumulatorTime += dt;
    while (accumulatorTime > sliceTimeMicroseconds) {
      update();
      accumulatorTime -= sliceTimeMicroseconds;
    }

    draw();
  });
}

void update() {
  _executeActions();
  _physicUpdate();
}

void _executeActions() {
  for (var i = 0; i < maxPlayers; i++) {
    // TODO sprawdz czy aby nie zatrzymuje za kazdym razem
    if (playerInputs[i].isBullet && !bulletTimers[i].isActive) {
      startBulletLoop(playerInputs[i]);
    } else if (!playerInputs[i].isBullet) {
      playerInputs[i].isBullet = false;
    }

    _registerAction(actionsStates[i]);
  }

  final registrations = actionsStates.map(_registerAction);
  registrations;
}

void _registerAction(ActionsState state) {
  if (!state.isBombCooldown) {
    state.isBombCooldown = true;
    if (state.bomb) {
      createBomb(state.id);
      Timer(Duration(seconds: bombCooldownSesconds), () {
        state.isBombCooldown = false;
        state.bomb = true;
      });
    }
  }

  if (!state.isDashCooldown) {
    state.isDashCooldown = true;
    if (state.dash) {
      // TODO
      // startDash();
      Timer(Duration(seconds: dashCooldownSesconds), () {
        state.isDashCooldown = false;
        state.dash = true;
      });
    }
  }
}

void _physicUpdate() {
  _bulletsPhysicUpdate();
  _bombsPhysicUpdate();
  _playersPhysicUpdate();
}

void _bulletsPhysicUpdate() {
  for (var i = 0; i < maxBullets; i++) {
    bulletPhysicUpdate(bullets[i], sliceTimeSeconds);
  }
}

void _bombsPhysicUpdate() {
  for (var i = 0; i < maxPlayers; i++) {
    bombPhysicUpdate(bombs[i], sliceTimeSeconds);
  }
}

void _playersPhysicUpdate() {
  for (var i = 0; i < maxPlayers; i++) {
    final state = playerInputs[i];
    playerPhysicUpdate(state);
  }
}

int currentBullet = 0;
void startBulletLoop(PlayerControlsState state) {
  if (currentBullet == maxBullePerPlayer) {
    currentBullet = 0;
  }

  createBullet(currentBullet, state.playerId);
  bulletTimers[state.playerId] = Timer.periodic(
    Duration(milliseconds: bulletsCooldownMilisesconds),
    (timer) {
      if (!state.isBullet) {
        timer.cancel();
      }

      if (currentBullet == maxBullePerPlayer) {
        currentBullet = 0;
      }

      createBullet(currentBullet, state.playerId);
      currentBullet++;
    },
  );
}

void createBullet(int id, int playerId) {
  final player = players[playerId];
  final velocity = Vector2(sin(player.angle), -cos(player.angle)).normalized()
    ..scale(initBulletScale);

  final position = Vector2(player.x, player.y);
  bullets[id]
    ..shooterId = playerId
    ..velocity = velocity
    ..angle = player.angle
    ..startPosition = position
    ..position = position;
}

void draw() {
  final bytes = GameState.bytes(
    players,
    bombs,
    hits,
    bullets,
    frags,
  );

  // TODO
  // bombs = [];
  // hits = [];

  for (var channel in gameStateChannels) {
    channel.sink.add(bytes);
  }
}
