import 'package:bubble_fight/ws.dart';
import 'package:core/core.dart';

final gameDataWs = Ws(Socket.gameDataWs, GameData.fromString);
final gameStateWs = Ws(Socket.gameStateWs, GameState.fromBytes);
