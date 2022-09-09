import 'dart:async';
import 'dart:convert';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';
import 'package:uuid/uuid.dart';

import '../setup.dart';

Future<Response> createPlayerHandler(Request request) async {
  final body = await request.readAsString();
  final json = jsonDecode(body);
  final dto = CreatePlayerDtoRequest.fromJson(json);
  final id = createPlayer(dto.guid);
  final response = CreatePlayerDtoResponse(id: id);

  return Response.ok(jsonEncode(response.toJson()));
}

Future<Response> createTestPlayerHandler(_) async {
  final guid = Uuid().v4().hashCode;
  createPlayer(guid);
  return Response.ok(null);
}

int createPlayer(int guid) {
  if (players.keys.contains(guid)) {
    return players[guid]!;
  }

  final id = ++ids;
  playerPositions[id] = [0.0, 0.0, 0.0];
  playerKnobs[id] = [0.0, 0.0, 0.0];

  players[guid] = id;
  final List<int> data = [2, id, guid];
  for (var channel in channels) {
    channel.sink.add(data);
  }
  return id;
}
