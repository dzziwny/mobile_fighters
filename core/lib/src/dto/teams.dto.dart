// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'teams.dto.freezed.dart';
part 'teams.dto.g.dart';

@freezed
class TeamsDto with _$TeamsDto {
  @JsonSerializable(explicitToJson: true)
  const factory TeamsDto({
    required List<String> material,
    required List<String> cupertino,
    required List<String> fluent,
    required List<String> spectators,
  }) = _TeamsDto;

  factory TeamsDto.fromJson(Map<String, dynamic> json) =>
      _$TeamsDtoFromJson(json);
}
