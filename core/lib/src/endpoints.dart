class Endpoint {
  static const connect = '/connect';
  static const play = '/play';
  static const startGame = '/startGame';
  static const leaveGame = '/leaveGame';
  static const gameFrame = '/gameFrame';
  static const setGamePhysics = '/setGamePhysics';
}

class Socket {
  /// Data about players - names, teams, ids, etc.
  static var gameDataWs = Socket('metadata');

  /// Mobile player can send state here to move, attack, etc.
  static var mobileControlsWs = Socket('mobilePlayerControls');

  /// Mobile player can send state here to move, attack, etc.
  static var desktopControlsWs = Socket('desktopPlayerControls');

  /// Player can get game state here about positions, bullets, bombs, frags etc.
  static var gameStateWs = Socket('gameState');

  Socket(String name) : _base = '/$name/ws';

  final String _base;

  String route({int? id}) => '$_base/${id ?? '<id>'}';
}
