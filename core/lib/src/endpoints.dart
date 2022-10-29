class Endpoint {
  static const createPlayer = '/createPlayer';
  static const createTestPlayer = '/createTestPlayer';
  static const getAllPlayers = '/players';
  static const leaveGame = '/leaveGame';
  static const gameFrame = '/gameFrame';
  static const rawDataWs = '/positions/ws';
  static const playersWs = '/players/ws';
  static const playerChangeWs = '/playerChange/ws';
  static const attackWs = '/attack/ws';
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
