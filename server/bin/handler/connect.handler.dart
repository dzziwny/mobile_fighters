import 'dart:convert';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';

import '../setup.dart';

Future<Response> connectHandler(Request request) async {
  final body = await request.readAsString();
  final json = jsonDecode(body);
  final dto = ConnectRequestDto.fromJson(json);
  final id = guids[dto.guid];
  if (id == null) {
    return Response.ok(jsonEncode(ConnectResponseDto()));
  }

  final metadata = playerMetadatas[id];
  final responseDto = ConnectResponseDto(id: metadata.isActive ? id : null);
  return Response.ok(jsonEncode(responseDto));
}
