import 'dart:async';
import 'dart:convert';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';

import '../setup.dart';

Future<Response> leaveGameHandler(Request request) async {
  final body = await request.readAsString();
  final json = jsonDecode(body);
  final dto = LeaveGameDtoRequest.fromJson(json);

  final id = guids.remove(dto.guid);

  if (id == null) {
    return Response.ok(null);
  }

  playerPositions.remove(id);
  playerKnobs.remove(id);
  players.remove(id);

  _sharePlayers();
  _sharePlayerRemoved(id);
  return Response.ok(null);
}

void _sharePlayerRemoved(int id) {
  final dto = PlayerChangeDto(
    id: id,
    nick: '',
    type: PlayerChangeType.removed,
  );

  final data = jsonEncode(dto);
  for (final channel in playerChangeWSChannels) {
    channel.sink.add(data);
  }
}

void _sharePlayers() {
  for (final channel in playersWSChannels) {
    final data = jsonEncode(players.values.toList());
    channel.sink.add(data);
  }
}
