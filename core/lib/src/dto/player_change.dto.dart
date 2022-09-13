// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_change.dto.freezed.dart';
part 'player_change.dto.g.dart';

enum PlayerChangeType {
  added,
  removed,
}

@freezed
class PlayerChangeDto with _$PlayerChangeDto {
  @JsonSerializable(explicitToJson: true)
  const factory PlayerChangeDto({
    required int id,
    required PlayerChangeType type,
    required String nick,
  }) = _PlayerChangeDto;

  factory PlayerChangeDto.fromJson(Map<String, dynamic> json) =>
      _$PlayerChangeDtoFromJson(json);
}
