import 'dart:convert';

import 'package:core/src/endpoints.dart';
import 'package:http/http.dart';

import 'connect.dto.dart';

Future<ConnectResponseDto> connect$(String guid, String base) async {
  final response = await post(
    Uri.parse('$base${Endpoint.connect}'),
    body: jsonEncode(
      ConnectRequestDto(guid: guid).toJson(),
    ),
  );

  final dto = ConnectResponseDto.fromJson(jsonDecode(response.body));
  return dto;
}
