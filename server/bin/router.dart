import 'package:core/core.dart';
import 'package:shelf_router/shelf_router.dart';

import 'handler/_handler.dart';
import 'handler/on_connection.dart';

extension WithWeb on Router {
  void ws(
    String Function({String id, bool isWeb}) routeBuilder,
    OnConnection onConnection,
  ) {
    final mobileRoute = routeBuilder(isWeb: false);
    get(mobileRoute, onConnection.handler(false));

    final webRoute = routeBuilder(isWeb: true);
    get(webRoute, onConnection.handler(true));
  }
}

final router = Router()
  ..post(Endpoint.createPlayer, createPlayerHandler)
  ..post(Endpoint.createTestPlayer, createTestPlayerHandler)
  ..get(Endpoint.gameFrame, gameFrameHandler)
  ..post(Endpoint.leaveGame, leaveGameHandler)
  ..ws(Endpoint.pushWsTemplate, PushConnection())
  ..ws(Endpoint.cooldownWsTemplate, CooldownConnection())
  ..ws(Endpoint.attackWsTemplate, AttackConnection())
  ..ws(Endpoint.deadWsTemplate, DeadConnection())
  ..ws(Endpoint.selectTeamWsTemplate, TeamConnection())
  ..ws(Endpoint.gamePhaseWsTemplate, GamePhaseConnection())
  ..ws(Endpoint.playersWs, PlayersConnection())
  ..ws(Endpoint.playerChangeWs, PlayerChangeConnection())
  ..ws(Endpoint.hitWs, HitConnection());
