import 'dart:async';
import 'dart:convert';

import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';

import '../game_runner.dart';
import '../game.dart';

Future<Response> leaveGameHandler(Request request) async {
  final game = GetIt.I<Game>();
  final runner = GetIt.I<GameRunner>();

  final body = await request.readAsString();
  final json = jsonDecode(body);
  final dto = LeaveGameDtoRequest.fromJson(json);
  final id = game.guids[dto.guid];
  if (id == null || id != dto.id) {
    return Response.ok(null);
  }

  game.removePlayer(id);
  final isAnyPlayer = game.players.any((player) => player.isActive);
  if (!isAnyPlayer) {
    runner.stopGame();
  }

  game.shareGameData();
  return Response.ok(null);
}
