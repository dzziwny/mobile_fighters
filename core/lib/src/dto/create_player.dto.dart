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
