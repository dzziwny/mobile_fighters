// ignore_for_file: invalid_annotation_target

import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'teams.dto.freezed.dart';
part 'teams.dto.g.dart';

@freezed
class TeamsDto with _$TeamsDto {
  @JsonSerializable(explicitToJson: true)
  const factory TeamsDto({
    required List<String> red,
    required List<String> blue,
  }) = _TeamsDto;

  factory TeamsDto.fromJson(Map<String, dynamic> json) =>
      _$TeamsDtoFromJson(json);

  factory TeamsDto.parse(String data) => TeamsDto.fromJson(jsonDecode(data));
}
