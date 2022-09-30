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
  playerSpeed[id] = normalSpeed;
  playerHp[id] = 100;

  final model = Player(id: id, nick: dto.nick);
  players[id] = model;

  guids[guid] = id;
  _sharePlayers();
  _sharePlayerCreated(id);
  return id;
}

void _sharePlayerCreated(int id) {
  final player = players[id];
  if (player == null) {
    return;
  }

  final dto = PlayerChangeDto(
    id: id,
    nick: player.nick,
    type: PlayerChangeType.added,
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
