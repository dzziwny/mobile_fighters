import 'package:bubble_fight/60hz_refreshable_playground/playground_controls_wrapper.dart';
import 'package:bubble_fight/controls/controls.bloc.dart';
import 'package:bubble_fight/game_state/game_state.service.dart';
import 'package:bubble_fight/game_state/game_state_ws.dart';
import 'package:bubble_fight/server_client.dart';
import 'package:flutter/material.dart';

import 'uuid.dart';

// Just call to create instances
Future<void> initializeInstances() async {
  uuid = await getUuid();
  serverClient = ServerClient(uuid: uuid);
  gameDataWs;
  gameStateWs;
  playgroundFocusNode = FocusNode();
  controlsBloc;
  gameService;
}
