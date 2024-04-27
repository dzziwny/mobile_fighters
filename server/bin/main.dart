import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_cors_headers/shelf_cors_headers.dart';
import 'package:shelf_router/shelf_router.dart';

import 'controls/desktop_controls.connection.dart';
import 'controls/mobile_controls.connection.dart';
import 'game_runner.dart';
import 'handler/_handler.dart';
import 'handler/connect.handler.dart';
import 'handler/game_data.connection.dart';
import 'handler/on_connection.dart';
import 'game_setup.dart';

extension WithWeb on Router {
  void ws(Socket endpoint, OnConnection onConnection) =>
      get(endpoint.route(), onConnection.handler());
}

void main(List<String> args) async {
  GetIt.I.registerSingleton(GameSetup());
  GetIt.I.registerSingleton(GameRunner());
  final ip = '0.0.0.0';
  final router = Router()
    ..get('/ping', (Request req) => Response.ok('ping'))
    ..get('/version', (Request req) => Response.ok('1.0.0'))
    ..get(Endpoint.gameFrame, gameFrameHandler)
    ..post(Endpoint.connect, connectHandler)
    ..post(Endpoint.play, playHandler)
    ..post(Endpoint.leaveGame, leaveGameHandler)
    ..post(Endpoint.setGameSettings, setGameSettingsHandler)
    ..ws(Socket.mobileControlsWs, MobileControlsConnection())
    ..ws(Socket.desktopControlsWs, DesktopControlsConnection())
    ..ws(Socket.gameDataWs, GameDataConnection())
    ..ws(Socket.gameStateWs, GameStateConnection());

  final handler =
      Pipeline().addMiddleware(corsHeaders()).addHandler(router.call);

  final server = await serve(handler, ip, 80);
  print('Server listening on ${server.address.host}:${server.port}');
}
