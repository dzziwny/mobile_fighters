import 'dart:convert';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';

import '../setup.dart';

Future<Response> gameFrameHandler(Request request) async {
  final frame = GameFrame(
    sizex: frameWidth,
    sizey: frameHeight,
    // TODO to remove
    positionx: (frameWidth + 50.0) / 2,
    positiony: (frameHeight + 50.0) / 2,
  );

  final data = jsonEncode(frame);
  return Response.ok(data);
}
