import 'dart:convert';
import 'package:http/http.dart';

import 'dto/_dto.dart';
import 'endpoints.dart';
import 'model/_model.dart';

final port = '8080';
final host = '192.168.0.171';
// final host = '192.168.1.25';
final base = 'http://$host:$port';

Future<CreatePlayerDtoResponse> createPlayer$(int guid, String nick) async {
  final response = await post(
    Uri.parse('$base${Endpoint.createPlayer}'),
    body: jsonEncode(CreatePlayerDtoRequest(
      guid: guid,
      nick: nick,
    ).toJson()),
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

Future<Response> getPlayersResponse$() => get(
      Uri.parse('$base${Endpoint.getAllPlayers}'),
    );

Future<List<Player>> getPlayers$() async {
  final response = await getPlayersResponse$();
  final List list = jsonDecode(response.body);
  final players = list.map((json) => Player.fromJson(json)).toList();

  return players;
}

Future<void> leaveGame$(int guid) => post(
      Uri.parse('$base${Endpoint.leaveGame}'),
      body: jsonEncode(
        LeaveGameDtoRequest(guid: guid).toJson(),
      ),
    );
