import 'package:freezed_annotation/freezed_annotation.dart';

part 'leave_game.dto.freezed.dart';
part 'leave_game.dto.g.dart';

@freezed
class LeaveGameDtoRequest with _$LeaveGameDtoRequest {
  const factory LeaveGameDtoRequest({
    required String guid,
    required int id,
  }) = _LeaveGameDtoRequest;

  factory LeaveGameDtoRequest.fromJson(Map<String, dynamic> json) =>
      _$LeaveGameDtoRequestFromJson(json);
}
