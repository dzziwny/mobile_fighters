import 'dart:convert';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';

Future<Response> gameFrameHandler(Request request) async {
  final frame = GameFrame(
    sizex: battleGroundWidth,
    sizey: battleGroundHeight,
  );

  final data = jsonEncode(frame);
  return Response.ok(data);
}
