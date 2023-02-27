import 'dart:convert';
import 'package:http/http.dart';

import 'dto/_dto.dart';
import 'endpoints.dart';
import 'model/_model.dart';

final port = '8080';
// monte
// final host = '192.168.0.171';

// no internet
final host = '0.0.0.0';

// strzeszyn
// final host = '192.168.1.25';

// sii warszawa
// final host = '10.254.33.55';
final base = 'http://$host:$port';

Future<ConnectFromServerDto> connect$(String guid) async {
  final response = await post(
    Uri.parse('$base${Endpoint.connect}'),
    body: jsonEncode(
      ConnectToServerDto(guid: guid).toJson(),
    ),
  );

  final dto = ConnectFromServerDto.fromJson(jsonDecode(response.body));
  return dto;
}

Future<CreatePlayerDtoResponse> createPlayer$(
  String guid,
  int id,
  String nick,
  Device device,
) async {
  final response = await post(
    Uri.parse('$base${Endpoint.startGame}'),
    body: jsonEncode(
      CreatePlayerDtoRequest(
        guid: guid,
        id: id,
        nick: nick,
        device: device,
      ),
    ),
  );

  if (response.statusCode != 200) {
    throw Exception('Cannot create player');
  }

  final dto = CreatePlayerDtoResponse.fromJson(jsonDecode(response.body));
  return dto;
}

Future<GameFrame> gameFrame$() async {
  final response = await get(
    Uri.parse('$base${Endpoint.gameFrame}'),
  );

  final frame = GameFrame.fromJson(jsonDecode(response.body));
  return frame;
}

Future<void> leaveGame$(String guid, int id) => post(
      Uri.parse('$base${Endpoint.leaveGame}'),
      body: jsonEncode(
        LeaveGameDtoRequest(guid: guid, id: id).toJson(),
      ),
    );
