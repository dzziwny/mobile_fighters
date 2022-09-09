// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_players.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GetPlayersDtoResponse _$$_GetPlayersDtoResponseFromJson(
        Map<String, dynamic> json) =>
    _$_GetPlayersDtoResponse(
      players: (json['players'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(int.parse(k), e as int),
      ),
    );

Map<String, dynamic> _$$_GetPlayersDtoResponseToJson(
        _$_GetPlayersDtoResponse instance) =>
    <String, dynamic>{
      'players': instance.players.map((k, e) => MapEntry(k.toString(), e)),
    };
