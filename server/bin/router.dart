import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';

import 'handler/handler.dart';
import 'package:core/core.dart';

final router = Router()
  ..post(Endpoint.createPlayer, createPlayerHandler)
  ..post(Endpoint.createTestPlayer, createTestPlayerHandler)
  ..get(Endpoint.getAllPlayers, getPlayersHandler)
  ..post(Endpoint.leaveGame, leaveGameHandler)
  ..get(Endpoint.webSocket, webSocketHandler(socketHandler));