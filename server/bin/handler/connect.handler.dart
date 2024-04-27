import 'dart:convert';

import 'package:core/core.dart';
import 'package:get_it/get_it.dart';
import 'package:shelf/shelf.dart';

import '../game.dart';

Future<Response> connectHandler(Request request) async {
  final game = GetIt.I<Game>();

  final body = await request.readAsString();
  final json = jsonDecode(body);
  final dto = ConnectRequestDto.fromJson(json);
  final id = game.guids[dto.guid];
  if (id == null) {
    return Response.ok(jsonEncode(ConnectResponseDto()));
  }

  final metadata = game.playerMetadatas[id];
  final responseDto = ConnectResponseDto(id: metadata.isActive ? id : null);
  return Response.ok(jsonEncode(responseDto));
}
