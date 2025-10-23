// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leave_game.dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LeaveGameDtoRequestImpl _$$LeaveGameDtoRequestImplFromJson(
        Map<String, dynamic> json) =>
    _$LeaveGameDtoRequestImpl(
      guid: json['guid'] as String,
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$$LeaveGameDtoRequestImplToJson(
        _$LeaveGameDtoRequestImpl instance) =>
    <String, dynamic>{
      'guid': instance.guid,
      'id': instance.id,
    };
