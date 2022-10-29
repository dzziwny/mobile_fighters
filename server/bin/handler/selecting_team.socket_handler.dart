import 'dart:convert';

import 'package:core/core.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';

selectingTeamSocketHandler(String playerId) => (WebSocketChannel channel) {
      final id = int.tryParse(playerId);
      if (id == null) {
        return;
      }

      final player = players[id];
      if (player == null) {
        return;
      }

      teamsWSChannels[id] = channel;

      final dto = prepareTeams();
      final data = jsonEncode(dto);
      channel.sink.add(data);

      channel.stream.listen((data) => onData(player, data));
    };

void onData(Player player, dynamic data) {
  if (data is! List<int>) {
    return;
  }

  final type = data[0];
  switch (type) {
    case 0:
      return _selectTeam(player, data);

    case 1:
      return _startGame(player, data);

    case 2:
      return _endGame(player, data);
  }
}

void _selectTeam(Player player, List<int> data) {
  final team = data[1];
  switch (team) {
    case 0:
      cupertinoTeam[player.id] = player;
      materialTeam.remove(player.id);
      spectatorsTeam.remove(player.id);
      break;

    case 1:
      materialTeam[player.id] = player;
      cupertinoTeam.remove(player.id);
      spectatorsTeam.remove(player.id);
      break;
    default:
      return;
  }

  final dto = prepareTeams();
  for (var teamChannel in teamsWSChannels.values) {
    teamChannel.sink.add(jsonEncode(dto));
  }
}

void _startGame(Player player, List<int> data) {
  // final isHost = player.id == gameHost?.id;
  // if (!isHost) {
  //   return;
  // }

  phase = GamePhase.play;
  final data = [phase.index];
  for (var channel in gamePhaseWSChannels.values) {
    channel.sink.add(data);
  }
}

void _endGame(Player player, List<int> data) {
  // final isHost = player.id == gameHost?.id;
  // if (!isHost) {
  //   return;
  // }

  cupertinoTeam = {};
  materialTeam = {};
  spectatorsTeam = Map.of(players);
  // TODO reset positions and HPs
  shareTeams();

  phase = GamePhase.selectingTeam;
  final data = [phase.index];
  for (var channel in gamePhaseWSChannels.values) {
    channel.sink.add(data);
  }
}
