import 'dart:convert';

import 'package:core/core.dart';
import 'package:shelf/shelf.dart';
import 'package:synchronized/synchronized.dart';

import '../setup.dart';

var _idLock = Lock();
final _bits = List<int>.generate(256, (i) => i);
final _idsInUsage = <int, bool>{};

Future<int> _generateId() => _idLock.synchronized(() {
      for (var id in _bits) {
        if (_idsInUsage[id] != null) {
          continue;
        }

        _idsInUsage[id] = true;
        return id;
      }

      throw Exception('Attacks stack overflow xd');
    });

Future<Response> connectHandler(Request request) async {
  final body = await request.readAsString();
  final json = jsonDecode(body);
  final dto = ConnectToServerDto.fromJson(json);
  var id = guids[dto.guid];
  if (id != null) {
    return Response.ok(jsonEncode(ConnectFromServerDto(id: id)));
  }

  id = await _generateId();
  guids[dto.guid] = id;
  final responseDto = ConnectFromServerDto(id: id);

  final data = jsonEncode(responseDto);
  return Response.ok(data);
}
