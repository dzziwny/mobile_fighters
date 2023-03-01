import 'package:core/core.dart';
import 'package:shelf_router/shelf_router.dart';

import 'handler/_handler.dart';
import 'handler/on_connection.dart';

extension WithWeb on Router {
  void ws(Socket endpoint, OnConnection onConnection) =>
      get(endpoint.route(), onConnection.handler());
}

final router = Router()
  ..get(Endpoint.gameFrame, gameFrameHandler)
  ..post(Endpoint.connect, connectHandler)
  ..post(Endpoint.startGame, createPlayerHandler)
  ..post(Endpoint.leaveGame, leaveGameHandler)
  ..ws(Socket.pushWs, PushConnection())
  ..ws(Socket.dashWs, DashConnection())
  ..ws(Socket.cooldownWs, CooldownConnection())
  ..ws(Socket.attackWs, AttackConnection())
  ..ws(Socket.deadWs, DeadConnection())
  ..ws(Socket.selectTeamWs, TeamConnection())
  ..ws(Socket.gamePhaseWsTemplate, GamePhaseConnection())
  ..ws(Socket.playersWs, PlayersConnection())
  ..ws(Socket.playerChangeWs, PlayerChangeConnection())
  ..ws(Socket.hitWs, HitConnection());
