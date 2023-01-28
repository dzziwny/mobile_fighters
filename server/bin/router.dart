import 'dart:io';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'handler/_handler.dart';

// TODO: make some helper method to make it easy to work with endpoints (also for web)
final router = Router()
  ..post(Endpoint.createPlayer, createPlayerHandler)
  ..post(Endpoint.createTestPlayer, createTestPlayerHandler)
  ..get(Endpoint.getAllPlayers, getPlayersHandler)
  ..get(Endpoint.gameFrame, gameFrameHandler)
  ..post(Endpoint.leaveGame, leaveGameHandler)
  ..get(Endpoint.pushWsTemplate, (Request request, String id) async {
    final intId = int.tryParse(id);
    if (intId == null) {
      return Response(HttpStatus.badRequest);
    }

    final handler = webSocketHandler(
      (WebSocketChannel channel) => pushSocketHandler(channel, intId),
    );

    final response = await handler(request);
    return response;
  })
  ..get(Endpoint.pushWsWebTemplate, (Request request, String id) async {
    final intId = int.tryParse(id);
    if (intId == null) {
      return Response(HttpStatus.badRequest);
    }

    final handler = webSocketHandler(
      (WebSocketChannel channel) => pushSocketHandlerWeb(channel, intId),
    );

    final response = await handler(request);
    return response;
  })
  ..get(Endpoint.playersWs, webSocketHandler(playersSocketHandler))
  ..get(Endpoint.playerChangeWs, webSocketHandler(playerChangeSocketHandler))
  ..get(Endpoint.hitWs, webSocketHandler(hitSocketHandler))
  ..get(Endpoint.attackWsTemplate, (Request request, String id) async {
    final intId = int.tryParse(id);
    if (intId == null) {
      return Response(HttpStatus.badRequest);
    }

    final handler = webSocketHandler(
      (WebSocketChannel channel) => attackSocketConnection(channel, intId),
    );

    final response = await handler(request);
    return response;
  })
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
