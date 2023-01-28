class Endpoint {
  static const createPlayer = '/createPlayer';
  static const createTestPlayer = '/createTestPlayer';
  static const getAllPlayers = '/players';
  static const leaveGame = '/leaveGame';
  static const gameFrame = '/gameFrame';
  static const pushWsTemplate = '/push/ws/<id>';
  static pushWs(int playerId) => '/push/ws/$playerId';
  static const pushWsWebTemplate = '/positions/web/ws/<id>';
  static pushWsWeb(int playerId) => '/positions/web/ws/$playerId';
  static const playersWs = '/players/ws';
  static const playerChangeWs = '/playerChange/ws';
  static attackWs(int playerId) => '/attack/ws/$playerId';
  static const attackWsTemplate = '/attack/ws/<id>';
  static const hitWs = '/hit/ws';
  static const cooldownWsTemplate = '/cooldownWs/ws/<id>';
  static cooldownWs(int playerId) => '/cooldownWs/ws/$playerId';
  static const deadWsTemplate = '/deadWs/ws/<id>';
  static deadWs(int playerId) => '/deadWs/ws/$playerId';
  static const selectTeamWsTemplate = '/selectTeamWs/ws/<id>';
  static selectTeamWs(int playerId) => '/selectTeamWs/ws/$playerId';
  static const gamePhaseWsTemplate = '/gamePhaseWs/ws/<id>';
  static gamePhaseWs(int playerId) => '/gamePhaseWs/ws/$playerId';
}
