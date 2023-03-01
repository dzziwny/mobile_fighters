import 'dart:convert';
import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../setup.dart';
import 'on_connection.dart';

class TeamConnection extends OnConnection {
  @override
  void onInit(int playerId, WebSocketChannel channel) {
    teamsWSChannels[playerId] = channel;

    final dto = prepareTeams();
    final data = jsonEncode(dto);
    channel.sink.add(data);
  }

  @override
  void onData(int playerId, Uint8List data) {
    final player = players[playerId];
    if (player == null) {
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

  void _selectTeam(Player player, Uint8List data) {
    final team = data[1];
    switch (team) {
      case 0:
        redTeam[player.id] = player;
        blueTeam.remove(player.id);
        break;

      case 1:
        blueTeam[player.id] = player;
        redTeam.remove(player.id);
        break;
      default:
        return;
    }

    final dto = prepareTeams();
    for (var teamChannel in teamsWSChannels.values) {
      teamChannel.sink.add(jsonEncode(dto));
    }
  }

  void _startGame(Player player, Uint8List data) {
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

  void _endGame(Player player, Uint8List data) {
    // final isHost = player.id == gameHost?.id;
    // if (!isHost) {
    //   return;
    // }

    redTeam = {};
    blueTeam = {};
    // TODO reset positions and HPs
    shareTeams();

    phase = GamePhase.selectingTeam;
    final data = [phase.index];
    for (var channel in gamePhaseWSChannels.values) {
      channel.sink.add(data);
    }
  }
}
