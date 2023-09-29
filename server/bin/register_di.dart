import 'dart:async';

import 'package:core/core.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'inputs/player_state_input.dart';

final playerInputs = List.generate(10, (id) => PlayerControlsState(id));
final actionsStates = List.generate(10, (id) => ActionsState(id));

final bulletTimers = List.generate(
  maxPlayers,
  (_) => Timer(Duration.zero, () {})..cancel(),
);

final bombTimers = List.generate(
  maxPlayers,
  (_) => Timer(Duration.zero, () {})..cancel(),
);

final List<WebSocketChannel> gameStateChannels = [];
final List<WebSocketChannel> gameDataChannels = [];
