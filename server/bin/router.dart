import 'package:core/core.dart';
import 'package:shelf_router/shelf_router.dart';

import 'handler/_handler.dart';
import 'handler/on_connection.dart';

extension WithWeb on Router {
  void ws(
    Endpoint endpoint,
    OnConnection onConnection,
  ) {
    final mobileRoute = endpoint.build(isWeb: false);
    get(mobileRoute, onConnection.handler(false));

    final webRoute = endpoint.build(isWeb: true);
    get(webRoute, onConnection.handler(true));
  }
}

final router = Router()
  ..get(Endpoint.gameFrame, gameFrameHandler)
  ..post(Endpoint.createPlayer, createPlayerHandler)
  ..post(Endpoint.createTestPlayer, createTestPlayerHandler)
  ..post(Endpoint.leaveGame, leaveGameHandler)
  ..ws(Endpoint.pushWs, PushConnection())
  ..ws(Endpoint.dashWs, DashConnection())
  ..ws(Endpoint.cooldownWs, CooldownConnection())
  ..ws(Endpoint.attackWs, AttackConnection())
  ..ws(Endpoint.deadWs, DeadConnection())
  ..ws(Endpoint.selectTeamWs, TeamConnection())
  ..ws(Endpoint.gamePhaseWsTemplate, GamePhaseConnection())
  ..ws(Endpoint.playersWs, PlayersConnection())
  ..ws(Endpoint.playerChangeWs, PlayerChangeConnection())
  ..ws(Endpoint.hitWs, HitConnection());
