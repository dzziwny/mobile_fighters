import 'dart:convert';

import 'package:core/src/model/_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_change.dto.freezed.dart';
part 'player_change.dto.g.dart';

@freezed
class PlayerChangeDto with _$PlayerChangeDto {
  const factory PlayerChangeDto({
    required int id,
    required PlayerChangeType type,
    required String nick,
    required Team team,
  }) = _PlayerChangeDto;

  factory PlayerChangeDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerChangeDtoFromJson(json);

  factory PlayerChangeDto.parse(String data) =>
      PlayerChangeDto.fromJson(jsonDecode(data));
}
