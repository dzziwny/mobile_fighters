import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';
import 'package:uuid/uuid.dart';

import '../setup.dart';

Future<Response> createPlayerHandler(Request request) async {
  final body = await request.readAsString();
  final json = jsonDecode(body);
  final dto = CreatePlayerDtoRequest.fromJson(json);
  final id = createPlayer(dto);
  final response = CreatePlayerDtoResponse(id: id);

  return Response.ok(jsonEncode(response.toJson()));
}

Future<Response> createTestPlayerHandler(_) async {
  final guid = Uuid().v4().hashCode;
  createPlayer(CreatePlayerDtoRequest(guid: guid, nick: 'test'));
  return Response.ok(null);
}

int createPlayer(CreatePlayerDtoRequest dto) {
  final guid = dto.guid;
  var id = guids[guid];
  if (id != null) {
    return id;
  }

  id = ++ids;
  final randomX = minX + Random().nextInt((maxX - minX).toInt());
  final randomY = minY + Random().nextInt((maxY - minY).toInt());
  playerPositions[id] = [randomX, randomY, 0.0];
  playerKnobs[id] = [0.0, 0.0, 0.0];

  final model = Player(id: id, nick: dto.nick);
  players[id] = model;

  guids[guid] = id;
  sharePlayers();
  sharePlayerCreated(id);
  return id;
}
