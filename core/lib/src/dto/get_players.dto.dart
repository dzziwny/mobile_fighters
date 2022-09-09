// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'get_players.dto.freezed.dart';
part 'get_players.dto.g.dart';

@freezed
class GetPlayersDtoResponse with _$GetPlayersDtoResponse {
  @JsonSerializable(explicitToJson: true)
  const factory GetPlayersDtoResponse({
    required Map<int, int> players,
  }) = _GetPlayersDtoResponse;

  factory GetPlayersDtoResponse.fromJson(Map<String, dynamic> json) =>
      _$GetPlayersDtoResponseFromJson(json);
}
