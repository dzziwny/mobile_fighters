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
// final host = '10.254.33.19';
final base = 'http://$host:$port';

Future<ConnectFromServerDto> connect$(String guid, String ip) async {
  final response = await post(
    Uri.parse('$ip${Endpoint.connect}'),
    body: jsonEncode(
      ConnectToServerDto(guid: guid).toJson(),
    ),
  );

  final dto = ConnectFromServerDto.fromJson(jsonDecode(response.body));
  return dto;
}

Future<void> createPlayer$(
  String guid,
  String ip,
  int id,
  String nick,
  Device device,
) async {
  final response = await post(
    Uri.parse('$ip${Endpoint.startGame}'),
    body: jsonEncode(
      CreatePlayerDtoRequest(
        guid: guid,
        id: id,
        nick: nick,
        device: device,
      ),
    ),
  );

  if (response.statusCode != 204) {
    throw Exception('Cannot create player');
  }
}

Future<GameFrame> gameFrame$(
  String ip,
) async {
  final response = await get(
    Uri.parse('$ip${Endpoint.gameFrame}'),
  );

  final frame = GameFrame.fromJson(jsonDecode(response.body));
  return frame;
}

Future<void> leaveGame$(String guid, int id, String ip) => post(
      Uri.parse('$ip${Endpoint.leaveGame}'),
      body: jsonEncode(
        LeaveGameDtoRequest(guid: guid, id: id).toJson(),
      ),
    );

Future<void> setGamePhysics$(GamePhysics physics, String ip) => post(
      Uri.parse('$ip${Endpoint.setGamePhysics}'),
      body: physics.toString(),
    );
