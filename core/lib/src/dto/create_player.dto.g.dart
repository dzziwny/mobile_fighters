// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_player.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CreatePlayerDtoRequestImpl _$$CreatePlayerDtoRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$CreatePlayerDtoRequestImpl(
      id: json['id'] as int,
      guid: json['guid'] as String,
      nick: json['nick'] as String,
      device: $enumDecode(_$DeviceEnumMap, json['device']),
    );

Map<String, dynamic> _$$CreatePlayerDtoRequestImplToJson(
        _$CreatePlayerDtoRequestImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'guid': instance.guid,
      'nick': instance.nick,
      'device': _$DeviceEnumMap[instance.device]!,
    };

const _$DeviceEnumMap = {
  Device.pixel: 'pixel',
  Device.iphone: 'iphone',
};
