import 'dart:convert';
import 'dart:io';

import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';

import '../game_runner.dart';
import '../game_setup.dart';

Future<Response> playHandler(Request request) async {
  final runner = GetIt.I<GameRunner>();
  final setup = GetIt.I<GameSetup>();

  final body = await request.readAsString();
  final json = jsonDecode(body);
  final dto = PlayToServerDto.fromJson(json);
  final guidId = setup.guids[dto.guid];
  if (guidId != null) {
    return Response.ok(jsonEncode(PlayFromServerDto(id: guidId)));
  }

  var id = setup.assignPlayerId();
  if (id == null) {
    return Response(
      HttpStatus.badRequest,
      body: 'Player could not be assigned an ID',
    );
  }

  setup.guids[dto.guid] = id;
  await setup.createPlayer(id, dto);
  final responseDto = PlayFromServerDto(id: id);
  runner.tryStartGame();
  return Response.ok(jsonEncode(responseDto));
}
