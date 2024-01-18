import 'package:bubble_fight/60hz_refreshable_playground/playground_layer.dart';
import 'package:bubble_fight/controls/controls.bloc.dart';
import 'package:bubble_fight/game_state/game_state.service.dart';
import 'package:bubble_fight/game_state/game_state_ws.dart';
import 'package:bubble_fight/server_client.dart';
import 'package:bubble_fight/start_window/start_window.controller.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'shared_preferences.dart';
import 'uuid.dart';

// Just call to create instances
Future<void> initializeInstances() async {
  prefs = await SharedPreferences.getInstance();
  uuid = getUuid(prefs);
  serverClient = ServerClient(uuid: uuid);
  // final ip = prefs.getString('previousIp');
  // final ip = '13.60.19.89:8080';
  // if (ip != null) {
  //   final isReconnected = await serverClient.tryReconnect(uuid, ip);
  //   if (isReconnected) {
  //     startWindowController.set(false);
  //     playgroundFocusNode.requestFocus();
  //   }
  // }

  gameDataWs;
  gameStateWs;
  playgroundFocusNode;
  controlsBloc;
  gameService;
  startWindowController;
}

late final WebSocketChannel test;
