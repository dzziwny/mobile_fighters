import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';

import '../game_runner.dart';
import '../game.dart';

Future<Response> playHandler(Request request) async {
  final runner = GetIt.I<GameRunner>();
  final game = GetIt.I<Game>();

  final body = await request.readAsString();
  final json = jsonDecode(body);
  final dto = PlayToServerDto.fromJson(json);
  final guidId = game.guids[dto.guid];
  if (guidId != null) {
    return Response.ok(jsonEncode(PlayFromServerDto(id: guidId)));
  }

  var id = game.assignPlayerId();
  if (id == null) {
    return Response(
      HttpStatus.badRequest,
      body: 'Player could not be assigned an ID',
    );
  }

  game.guids[dto.guid] = id;
  await game.createPlayer(id, dto);
  final responseDto = PlayFromServerDto(id: id);
  runner.tryStartGame();
  return Response.ok(jsonEncode(responseDto));
}
