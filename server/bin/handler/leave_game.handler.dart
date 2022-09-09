import 'dart:async';
import 'dart:convert';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';

import '../setup.dart';

Future<Response> leaveGameHandler(Request request) async {
  final body = await request.readAsString();
  final json = jsonDecode(body);
  final dto = LeaveGameDtoRequest.fromJson(json);

  final id = players.remove(dto.guid);

  if (id == null) {
    return Response.ok(null);
  }

  playerPositions.remove(id);
  playerKnobs.remove(id);

  sharePlayerRemoved(id);
  return Response.ok(null);
}

void sharePlayerRemoved(int playerId) {
  final data = <int>[2, playerId];
  for (var channel in channels) {
    channel.sink.add(data);
  }
}
