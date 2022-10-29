// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_change.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PlayerChangeDto _$$_PlayerChangeDtoFromJson(Map<String, dynamic> json) =>
    _$_PlayerChangeDto(
      id: json['id'] as int,
      type: $enumDecode(_$PlayerChangeTypeEnumMap, json['type']),
      nick: json['nick'] as String,
      team: $enumDecode(_$TeamEnumMap, json['team']),
    );

Map<String, dynamic> _$$_PlayerChangeDtoToJson(_$_PlayerChangeDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$PlayerChangeTypeEnumMap[instance.type]!,
      'nick': instance.nick,
      'team': _$TeamEnumMap[instance.team]!,
    };

const _$PlayerChangeTypeEnumMap = {
  PlayerChangeType.added: 'added',
  PlayerChangeType.removed: 'removed',
};

const _$TeamEnumMap = {
  Team.material: 'material',
  Team.cupertino: 'cupertino',
  Team.fluent: 'fluent',
  Team.spectator: 'spectator',
};
