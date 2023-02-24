import 'dart:io';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import 'handler/_handler.dart';
import 'handler/on_connection.dart';

extension WithWeb on Router {
  void ws(
    String Function({String id, bool isWeb}) routeBuilder,
    OnConnection onConnection,
  ) {
    final mobileRoute = routeBuilder(isWeb: false);
    get(mobileRoute, _onConnection(onConnection, false));

    final webRoute = routeBuilder(isWeb: true);
    get(webRoute, _onConnection(onConnection, true));
  }
}

final router = Router()
  ..post(Endpoint.createPlayer, createPlayerHandler)
  ..post(Endpoint.createTestPlayer, createTestPlayerHandler)
  ..get(Endpoint.getAllPlayers, getPlayersHandler)
  ..get(Endpoint.gameFrame, gameFrameHandler)
  ..post(Endpoint.leaveGame, leaveGameHandler)
  ..ws(Endpoint.pushWsTemplate, PushConnection())
  ..ws(Endpoint.cooldownWsTemplate, CooldownConnection())
  ..ws(Endpoint.attackWsTemplate, AttackConnection())
  ..ws(Endpoint.deadWsTemplate, DeadConnection())
  ..ws(Endpoint.selectTeamWsTemplate, TeamConnection())
  ..ws(Endpoint.gamePhaseWsTemplate, GamePhaseConnection())
  ..get(Endpoint.playersWs, webSocketHandler(playersSocketHandler))
  ..get(Endpoint.playerChangeWs, webSocketHandler(playerChangeSocketHandler))
  ..get(Endpoint.hitWs, webSocketHandler(hitSocketHandler));

_id(void Function(WebSocketChannel, int) onConnection) =>
    (Request request, String id) async {
      final intId = int.tryParse(id);
      if (intId == null) {
        return Response(HttpStatus.badRequest);
      }

      final handler = webSocketHandler(
        (WebSocketChannel channel) => onConnection(channel, intId),
      );

      final response = await handler(request);
      return response;
    };

_onConnection(OnConnection onConnection, bool isWeb) =>
    (Request request, String id) async {
      final intId = int.tryParse(id);
      if (intId == null) {
        return Response(HttpStatus.badRequest);
      }

      final method = isWeb ? onConnection.handleWeb : onConnection.handleMobile;
      final handler = webSocketHandler(
        (WebSocketChannel channel) => method(channel, intId),
      );

      final response = await handler(request);
      return response;
    };
