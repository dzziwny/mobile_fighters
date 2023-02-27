// ignore_for_file: invalid_annotation_target

import 'package:freezed_annotation/freezed_annotation.dart';

part 'leave_game.dto.freezed.dart';
part 'leave_game.dto.g.dart';

@freezed
class LeaveGameDtoRequest with _$LeaveGameDtoRequest {
  @JsonSerializable(explicitToJson: true)
  const factory LeaveGameDtoRequest({
    required int guid,
    required int id,
  }) = _LeaveGameDtoRequest;

  factory LeaveGameDtoRequest.fromJson(Map<String, dynamic> json) =>
      _$LeaveGameDtoRequestFromJson(json);
}
