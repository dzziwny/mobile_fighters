class Endpoint {
  static const createPlayer = '/createPlayer';
  static const createTestPlayer = '/createTestPlayer';
  static const leaveGame = '/leaveGame';
  static const gameFrame = '/gameFrame';
  static var playersWs = Endpoint('/players/ws');
  static var pushWs = Endpoint('/push/ws');
  static var cooldownWs = Endpoint('/cooldownWs/ws');
  static var attackWs = Endpoint('/attack/ws');
  static var deadWs = Endpoint('/deadWs/ws');
  static var selectTeamWs = Endpoint('/selectTeamWs/ws');
  static var gamePhaseWsTemplate = Endpoint('/gamePhaseWs/ws');
  static var playerChangeWs = Endpoint('/playerChange/ws');
  static var hitWs = Endpoint('/hit/ws');

  Endpoint(this._base);

  final String _base;

  String build({String id = '<id>', bool isWeb = false}) =>
      '${isWeb ? '/web' : ''}$_base/$id';
}
