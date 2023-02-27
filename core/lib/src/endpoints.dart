class Endpoint {
  static const connect = '/connect';
  static const startGame = '/startGame';
  static const leaveGame = '/leaveGame';
  static const gameFrame = '/gameFrame';
}

class Socket {
  static var playersWs = Socket('players');
  static var pushWs = Socket('push');
  static var dashWs = Socket('dash');
  static var cooldownWs = Socket('cooldownWs');
  static var attackWs = Socket('attack');
  static var deadWs = Socket('deadWs');
  static var selectTeamWs = Socket('selectTeamWs');
  static var gamePhaseWsTemplate = Socket('gamePhaseWs');
  static var playerChangeWs = Socket('playerChange');
  static var hitWs = Socket('hit');

  Socket(String name) : _base = '/$name/ws';

  final String _base;

  String build({String id = '<id>', bool isWeb = false}) =>
      '${isWeb ? '/web' : ''}$_base/$id';
}
