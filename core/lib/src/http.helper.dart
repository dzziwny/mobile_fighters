import 'dart:convert';
import 'package:http/http.dart';

import 'dto/_dto.dart';
import 'endpoints.dart';

final port = '8080';
final host = 'localhost';
final base = 'http://$host:$port';

Future<CreatePlayerDtoResponse> createPlayer$(int guid) async {
  final response = await post(
    Uri.parse('$base${Endpoint.createPlayer}'),
    body: jsonEncode(CreatePlayerDtoRequest(guid: guid).toJson()),
  );

  final dto = CreatePlayerDtoResponse.fromJson(jsonDecode(response.body));
  return dto;
}

Future<Response> getPlayersResponse$() => get(
      Uri.parse('$base${Endpoint.getAllPlayers}'),
    );

Future<Map<int, int>> getPlayers$() async {
  final response = await getPlayersResponse$();
  final dto = GetPlayersDtoResponse.fromJson(jsonDecode(response.body));
  return dto.players;
}

Future<void> leaveGame$(int guid) => post(
      Uri.parse('$base${Endpoint.leaveGame}'),
      body: jsonEncode(
        LeaveGameDtoRequest(guid: guid).toJson(),
      ),
    );
