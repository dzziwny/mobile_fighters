class Endpoint {
  static const createPlayer = '/createPlayer';
  static const createTestPlayer = '/createTestPlayer';
  static const getAllPlayers = '/players';
  static const leaveGame = '/leaveGame';
  static const gameFrame = '/gameFrame';
  static var pushWsTemplate = _builder('/push/ws');
  static var cooldownWsTemplate = _builder('/cooldownWs/ws');
  static var attackWsTemplate = _builder('/attack/ws');
  static var deadWsTemplate = _builder('/deadWs/ws');
  static var selectTeamWsTemplate = _builder('/selectTeamWs/ws');
  static var gamePhaseWsTemplate = _builder('/gamePhaseWs/ws');
  static const playersWs = '/players/ws';
  static const playerChangeWs = '/playerChange/ws';
  static const hitWs = '/hit/ws';

  static String Function({String id, bool isWeb}) _builder(String base) =>
      ({String id = '<id>', bool isWeb = false}) =>
          '${isWeb ? '/web' : ''}$base/$id';
}
