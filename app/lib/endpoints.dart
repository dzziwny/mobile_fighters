import 'package:core/core.dart';
import 'package:flutter/foundation.dart';

class Route {
  static var playersWs = _builder(Endpoint.playersWs);
  static var playerChangeWs = _builder(Endpoint.playerChangeWs);
  static var pushWs = _builder(Endpoint.pushWsTemplate);
  static var cooldownWs = _builder(Endpoint.cooldownWsTemplate);
  static var attackWs = _builder(Endpoint.attackWsTemplate);
  static var deadWs = _builder(Endpoint.deadWsTemplate);
  static var selectTeamWs = _builder(Endpoint.selectTeamWsTemplate);
  static var gamePhaseWs = _builder(Endpoint.gamePhaseWsTemplate);
  static var hitWs = _builder(Endpoint.hitWs);

  static String Function(int playerId) _builder(
      String Function({String id, bool isWeb}) builder) {
    return (int id) {
      final uri = builder(id: id.toString(), isWeb: kIsWeb);
      return uri;
    };
  }
}
