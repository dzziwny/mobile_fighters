import 'dart:convert';

import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';

import '../game_setup.dart';

Future<Response> connectHandler(Request request) async {
  final setup = GetIt.I<GameSetup>();

  final body = await request.readAsString();
  final json = jsonDecode(body);
  final dto = ConnectRequestDto.fromJson(json);
  final id = setup.guids[dto.guid];
  if (id == null) {
    return Response.ok(jsonEncode(ConnectResponseDto()));
  }

  final metadata = setup.playerMetadatas[id];
  final responseDto = ConnectResponseDto(id: metadata.isActive ? id : null);
  return Response.ok(jsonEncode(responseDto));
}
