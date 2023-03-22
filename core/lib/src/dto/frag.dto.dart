import 'dart:convert';

import 'package:core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'frag.dto.freezed.dart';
part 'frag.dto.g.dart';

@freezed
class FragDto with _$FragDto {
  const factory FragDto({
    required String killer,
    required Team killerTeam,
    required String enemy,
    required Team enemyTeam,
  }) = _FragDto;

  factory FragDto.fromJson(Map<String, dynamic> json) =>
      _$FragDtoFromJson(json);

  factory FragDto.parse(String data) => FragDto.fromJson(jsonDecode(data));
}
