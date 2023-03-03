import 'dart:convert';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';

import '../setup.dart';

Future<Response> gameFrameHandler(Request request) async {
  final frame = GameFrame(
    sizex: frameWidth,
    sizey: frameHeight,
  );

  final data = jsonEncode(frame);
  return Response.ok(data);
}
