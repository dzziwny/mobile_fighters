// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Player _$$_PlayerFromJson(Map<String, dynamic> json) => _$_Player(
      id: json['id'] as int,
      nick: json['nick'] as String,
      team: $enumDecode(_$TeamEnumMap, json['team']),
    );

Map<String, dynamic> _$$_PlayerToJson(_$_Player instance) => <String, dynamic>{
      'id': instance.id,
      'nick': instance.nick,
      'team': _$TeamEnumMap[instance.team]!,
    };

const _$TeamEnumMap = {
  Team.material: 'material',
  Team.cupertino: 'cupertino',
  Team.fluent: 'fluent',
  Team.spectator: 'spectator',
};
