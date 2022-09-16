import 'dart:convert';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';

Future<Response> gameFrameHandler(Request request) async {
  final frame = GameFrame(
    sizex: 750.0,
    sizey: 550.0,
    positionx: (750.0 + 50.0) / 2,
    positiony: (550.0 + 50.0) / 2,
  );

  final data = jsonEncode(frame);
  return Response.ok(data);
}
