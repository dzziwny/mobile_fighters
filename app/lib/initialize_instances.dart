import 'package:bubble_fight/controls/controls.bloc.dart';
import 'package:bubble_fight/game_state/game_state.service.dart';
import 'package:bubble_fight/game_state/game_state_ws.dart';
import 'package:bubble_fight/server_client.dart';

// Just call to create instances
void initializeInstances() {
  serverClient;
  gameDataWs;
  gameStateWs;
  controlsBloc;
  gameService;
}
