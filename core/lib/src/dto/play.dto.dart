import 'package:core/src/model/_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'play.dto.freezed.dart';
part 'play.dto.g.dart';

@freezed
class PlayToServerDto with _$PlayToServerDto {
  const factory PlayToServerDto({
    required String guid,
    required String nick,
    required Device device,
  }) = _PlayToServerDto;

  factory PlayToServerDto.fromJson(Map<String, dynamic> json) =>
      _$PlayToServerDtoFromJson(json);
}

@freezed
class PlayFromServerDto with _$PlayFromServerDto {
  const factory PlayFromServerDto({
    required int id,
  }) = _PlayFromServerDto;

  factory PlayFromServerDto.fromJson(Map<String, dynamic> json) =>
      _$PlayFromServerDtoFromJson(json);
}
