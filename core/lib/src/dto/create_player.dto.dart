// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'create_player.dto.freezed.dart';
part 'create_player.dto.g.dart';

@freezed
class CreatePlayerDtoRequest with _$CreatePlayerDtoRequest {
  @JsonSerializable(explicitToJson: true)
  const factory CreatePlayerDtoRequest({
    required int guid,
    required String nick,
  }) = _CreatePlayerDtoRequest;

  factory CreatePlayerDtoRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePlayerDtoRequestFromJson(json);
}

@freezed
class CreatePlayerDtoResponse with _$CreatePlayerDtoResponse {
  @JsonSerializable(explicitToJson: true)
  const factory CreatePlayerDtoResponse({
    required int id,
  }) = _CreatePlayerDtoResponse;

  factory CreatePlayerDtoResponse.fromJson(Map<String, dynamic> json) =>
      _$CreatePlayerDtoResponseFromJson(json);
}
