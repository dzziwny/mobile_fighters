// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Player _$$_PlayerFromJson(Map<String, dynamic> json) => _$_Player(
      id: json['id'] as int,
      nick: json['nick'] as String,
      team: $enumDecode(_$TeamEnumMap, json['team']),
      device: $enumDecode(_$DeviceEnumMap, json['device']),
    );

Map<String, dynamic> _$$_PlayerToJson(_$_Player instance) => <String, dynamic>{
      'id': instance.id,
      'nick': instance.nick,
      'team': _$TeamEnumMap[instance.team]!,
      'device': _$DeviceEnumMap[instance.device]!,
    };

const _$TeamEnumMap = {
  Team.material: 'material',
  Team.cupertino: 'cupertino',
  Team.fluent: 'fluent',
  Team.spectator: 'spectator',
};

const _$DeviceEnumMap = {
  Device.pixel: 'pixel',
  Device.iphone: 'iphone',
};
