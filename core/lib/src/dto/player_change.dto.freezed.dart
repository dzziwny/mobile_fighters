// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_change.dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

PlayerChangeDto _$PlayerChangeDtoFromJson(Map<String, dynamic> json) {
  return _PlayerChangeDto.fromJson(json);
}

/// @nodoc
mixin _$PlayerChangeDto {
  int get id => throw _privateConstructorUsedError;
  PlayerChangeType get type => throw _privateConstructorUsedError;
  String get nick => throw _privateConstructorUsedError;
  Team get team => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlayerChangeDtoCopyWith<PlayerChangeDto> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlayerChangeDtoCopyWith<$Res> {
  factory $PlayerChangeDtoCopyWith(
          PlayerChangeDto value, $Res Function(PlayerChangeDto) then) =
      _$PlayerChangeDtoCopyWithImpl<$Res, PlayerChangeDto>;
  @useResult
  $Res call({int id, PlayerChangeType type, String nick, Team team});
}

/// @nodoc
class _$PlayerChangeDtoCopyWithImpl<$Res, $Val extends PlayerChangeDto>
    implements $PlayerChangeDtoCopyWith<$Res> {
  _$PlayerChangeDtoCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? nick = null,
    Object? team = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PlayerChangeType,
      nick: null == nick
          ? _value.nick
          : nick // ignore: cast_nullable_to_non_nullable
              as String,
      team: null == team
          ? _value.team
          : team // ignore: cast_nullable_to_non_nullable
              as Team,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_PlayerChangeDtoCopyWith<$Res>
    implements $PlayerChangeDtoCopyWith<$Res> {
  factory _$$_PlayerChangeDtoCopyWith(
          _$_PlayerChangeDto value, $Res Function(_$_PlayerChangeDto) then) =
      __$$_PlayerChangeDtoCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, PlayerChangeType type, String nick, Team team});
}

/// @nodoc
class __$$_PlayerChangeDtoCopyWithImpl<$Res>
    extends _$PlayerChangeDtoCopyWithImpl<$Res, _$_PlayerChangeDto>
    implements _$$_PlayerChangeDtoCopyWith<$Res> {
  __$$_PlayerChangeDtoCopyWithImpl(
      _$_PlayerChangeDto _value, $Res Function(_$_PlayerChangeDto) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? nick = null,
    Object? team = null,
  }) {
    return _then(_$_PlayerChangeDto(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as PlayerChangeType,
      nick: null == nick
          ? _value.nick
          : nick // ignore: cast_nullable_to_non_nullable
              as String,
      team: null == team
          ? _value.team
          : team // ignore: cast_nullable_to_non_nullable
              as Team,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_PlayerChangeDto implements _PlayerChangeDto {
  const _$_PlayerChangeDto(
      {required this.id,
      required this.type,
      required this.nick,
      required this.team});

  factory _$_PlayerChangeDto.fromJson(Map<String, dynamic> json) =>
      _$$_PlayerChangeDtoFromJson(json);

  @override
  final int id;
  @override
  final PlayerChangeType type;
  @override
  final String nick;
  @override
  final Team team;

  @override
  String toString() {
    return 'PlayerChangeDto(id: $id, type: $type, nick: $nick, team: $team)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_PlayerChangeDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.nick, nick) || other.nick == nick) &&
            (identical(other.team, team) || other.team == team));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, type, nick, team);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_PlayerChangeDtoCopyWith<_$_PlayerChangeDto> get copyWith =>
      __$$_PlayerChangeDtoCopyWithImpl<_$_PlayerChangeDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PlayerChangeDtoToJson(
      this,
    );
  }
}

abstract class _PlayerChangeDto implements PlayerChangeDto {
  const factory _PlayerChangeDto(
      {required final int id,
      required final PlayerChangeType type,
      required final String nick,
      required final Team team}) = _$_PlayerChangeDto;

  factory _PlayerChangeDto.fromJson(Map<String, dynamic> json) =
      _$_PlayerChangeDto.fromJson;

  @override
  int get id;
  @override
  PlayerChangeType get type;
  @override
  String get nick;
  @override
  Team get team;
  @override
  @JsonKey(ignore: true)
  _$$_PlayerChangeDtoCopyWith<_$_PlayerChangeDto> get copyWith =>
      throw _privateConstructorUsedError;
}
