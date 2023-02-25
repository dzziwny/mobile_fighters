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

Future<CreatePlayerDtoResponse> createPlayer$(
  int guid,
  String nick,
  Device device,
) async {
  final response = await post(
    Uri.parse('$base${Endpoint.createPlayer}'),
    body: jsonEncode(
      // TODO check if jsonEncode is needed - in other methods too
      CreatePlayerDtoRequest(guid: guid, nick: nick, device: device).toJson(),
    ),
  );

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

Future<void> leaveGame$(int guid) => post(
      Uri.parse('$base${Endpoint.leaveGame}'),
      body: jsonEncode(
        LeaveGameDtoRequest(guid: guid).toJson(),
      ),
    );
