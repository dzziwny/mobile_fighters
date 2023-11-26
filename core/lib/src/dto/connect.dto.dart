import 'package:freezed_annotation/freezed_annotation.dart';

part 'connect.dto.freezed.dart';
part 'connect.dto.g.dart';

@freezed
class ConnectToServerDto with _$ConnectToServerDto {
  const factory ConnectToServerDto({
    required String guid,
  }) = _ConnectToServerDto;

  factory ConnectToServerDto.fromJson(Map<String, dynamic> json) =>
      _$ConnectToServerDtoFromJson(json);
}

@freezed
class ConnectFromServerDto with _$ConnectFromServerDto {
  const factory ConnectFromServerDto({
    required int id,
    required bool reconnected,
  }) = _ConnectFromServerDto;

  factory ConnectFromServerDto.fromJson(Map<String, dynamic> json) =>
      _$ConnectFromServerDtoFromJson(json);
}
