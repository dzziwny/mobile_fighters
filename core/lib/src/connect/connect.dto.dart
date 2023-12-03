import 'package:freezed_annotation/freezed_annotation.dart';

part 'connect.dto.freezed.dart';
part 'connect.dto.g.dart';

@freezed
class ConnectRequestDto with _$ConnectRequestDto {
  const factory ConnectRequestDto({
    required String guid,
  }) = _PlayRequestDto;

  factory ConnectRequestDto.fromJson(Map<String, dynamic> json) =>
      _$ConnectRequestDtoFromJson(json);
}

@freezed
class ConnectResponseDto with _$ConnectResponseDto {
  const factory ConnectResponseDto({
    int? id,
  }) = _ConnectFromServerDto;

  factory ConnectResponseDto.fromJson(Map<String, dynamic> json) =>
      _$ConnectResponseDtoFromJson(json);
}
