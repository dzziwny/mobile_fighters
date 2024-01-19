import 'dart:convert';

import 'package:core/src/game_settings.dart';
import 'package:http/http.dart';

import 'dto/_dto.dart';
import 'endpoints.dart';
import 'model/_model.dart';

const port = '8080';

// AWS
const host = '13.53.50.202';

// no internet
// final host = '0.0.0.0';

// sii warszawa
// final host = '10.254.33.19';
const base = 'http://$host:$port';

Future<PlayFromServerDto> play$(
    String guid, String ip, String nick, Device device) async {
  final response = await post(
    Uri.parse('$ip${Endpoint.play}'),
    body: jsonEncode(
      PlayToServerDto(
        guid: guid,
        nick: nick,
        device: device,
      ).toJson(),
    ),
  );

  final dto = PlayFromServerDto.fromJson(jsonDecode(response.body));
  return dto;
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

Future<void> setGameSettings$(GameSettings settings, String ip) => post(
      Uri.parse('$ip${Endpoint.setGameSettings}'),
      body: settings.toString(),
    );
