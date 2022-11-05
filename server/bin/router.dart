import 'package:core/core.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';

import 'handler/_handler.dart';

final router = Router()
  ..post(Endpoint.createPlayer, createPlayerHandler)
  ..post(Endpoint.createTestPlayer, createTestPlayerHandler)
  ..get(Endpoint.getAllPlayers, getPlayersHandler)
  ..get(Endpoint.gameFrame, gameFrameHandler)
  ..post(Endpoint.leaveGame, leaveGameHandler)
  ..get(Endpoint.rawDataWs, webSocketHandler(rawDataSocketHandler))
  ..get(Endpoint.rawDataWsWeb, webSocketHandler(rawDataSocketHandlerWeb))
  ..get(Endpoint.playersWs, webSocketHandler(playersSocketHandler))
  ..get(Endpoint.playerChangeWs, webSocketHandler(playerChangeSocketHandler))
  ..get(Endpoint.attackWs, webSocketHandler(attackSocketHandler))
  ..get(Endpoint.hitWs, webSocketHandler(hitSocketHandler))
  ..get(Endpoint.cooldownWsTemplate, (Request request, String id) {
    return webSocketHandler(cooldownSocketHandler(id))(request);
  })
  ..get(Endpoint.deadWsTemplate, (Request request, String id) {
    return webSocketHandler(deadSocketHandler(id))(request);
  })
  ..get(Endpoint.selectTeamWsTemplate, (Request request, String id) {
    return webSocketHandler(selectingTeamSocketHandler(id))(request);
  })
  ..get(Endpoint.gamePhaseWsTemplate, gamePhaseSocketHandler);
