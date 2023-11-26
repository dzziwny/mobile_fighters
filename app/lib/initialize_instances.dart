import 'package:bubble_fight/60hz_refreshable_playground/playground_control_wrapper.dart';
import 'package:bubble_fight/controls/controls.bloc.dart';
import 'package:bubble_fight/game_state/game_state.service.dart';
import 'package:bubble_fight/game_state/game_state_ws.dart';
import 'package:bubble_fight/server_client.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'shared_preferences.dart';
import 'uuid.dart';

// Just call to create instances
Future<void> initializeInstances() async {
  prefs = await SharedPreferences.getInstance();
  uuid;
  serverClient;
  gameDataWs;
  gameStateWs;
  playgroundFocusNode;
  controlsBloc;
  gameService;
}
