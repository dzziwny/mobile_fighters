import 'package:core/src/model/_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_player.dto.freezed.dart';
part 'create_player.dto.g.dart';

@freezed
class CreatePlayerDtoRequest with _$CreatePlayerDtoRequest {
  const factory CreatePlayerDtoRequest({
    required int id,
    required String guid,
    required String nick,
    required Device device,
  }) = _CreatePlayerDtoRequest;

  factory CreatePlayerDtoRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePlayerDtoRequestFromJson(json);
}

@freezed
class CreatePlayerDtoResponse with _$CreatePlayerDtoResponse {
  const factory CreatePlayerDtoResponse({
    required int id,
    required Team team,
    required Position position,
  }) = _CreatePlayerDtoResponse;

  factory CreatePlayerDtoResponse.fromJson(Map<String, dynamic> json) =>
      _$CreatePlayerDtoResponseFromJson(json);
}
