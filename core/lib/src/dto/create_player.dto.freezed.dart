// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'create_player.dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

CreatePlayerDtoRequest _$CreatePlayerDtoRequestFromJson(
    Map<String, dynamic> json) {
  return _CreatePlayerDtoRequest.fromJson(json);
}

/// @nodoc
mixin _$CreatePlayerDtoRequest {
  int get id => throw _privateConstructorUsedError;
  String get guid => throw _privateConstructorUsedError;
  String get nick => throw _privateConstructorUsedError;
  Device get device => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreatePlayerDtoRequestCopyWith<CreatePlayerDtoRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatePlayerDtoRequestCopyWith<$Res> {
  factory $CreatePlayerDtoRequestCopyWith(CreatePlayerDtoRequest value,
          $Res Function(CreatePlayerDtoRequest) then) =
      _$CreatePlayerDtoRequestCopyWithImpl<$Res, CreatePlayerDtoRequest>;
  @useResult
  $Res call({int id, String guid, String nick, Device device});
}

/// @nodoc
class _$CreatePlayerDtoRequestCopyWithImpl<$Res,
        $Val extends CreatePlayerDtoRequest>
    implements $CreatePlayerDtoRequestCopyWith<$Res> {
  _$CreatePlayerDtoRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? guid = null,
    Object? nick = null,
    Object? device = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      guid: null == guid
          ? _value.guid
          : guid // ignore: cast_nullable_to_non_nullable
              as String,
      nick: null == nick
          ? _value.nick
          : nick // ignore: cast_nullable_to_non_nullable
              as String,
      device: null == device
          ? _value.device
          : device // ignore: cast_nullable_to_non_nullable
              as Device,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_CreatePlayerDtoRequestCopyWith<$Res>
    implements $CreatePlayerDtoRequestCopyWith<$Res> {
  factory _$$_CreatePlayerDtoRequestCopyWith(_$_CreatePlayerDtoRequest value,
          $Res Function(_$_CreatePlayerDtoRequest) then) =
      __$$_CreatePlayerDtoRequestCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String guid, String nick, Device device});
}

/// @nodoc
class __$$_CreatePlayerDtoRequestCopyWithImpl<$Res>
    extends _$CreatePlayerDtoRequestCopyWithImpl<$Res,
        _$_CreatePlayerDtoRequest>
    implements _$$_CreatePlayerDtoRequestCopyWith<$Res> {
  __$$_CreatePlayerDtoRequestCopyWithImpl(_$_CreatePlayerDtoRequest _value,
      $Res Function(_$_CreatePlayerDtoRequest) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? guid = null,
    Object? nick = null,
    Object? device = null,
  }) {
    return _then(_$_CreatePlayerDtoRequest(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      guid: null == guid
          ? _value.guid
          : guid // ignore: cast_nullable_to_non_nullable
              as String,
      nick: null == nick
          ? _value.nick
          : nick // ignore: cast_nullable_to_non_nullable
              as String,
      device: null == device
          ? _value.device
          : device // ignore: cast_nullable_to_non_nullable
              as Device,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CreatePlayerDtoRequest implements _CreatePlayerDtoRequest {
  const _$_CreatePlayerDtoRequest(
      {required this.id,
      required this.guid,
      required this.nick,
      required this.device});

  factory _$_CreatePlayerDtoRequest.fromJson(Map<String, dynamic> json) =>
      _$$_CreatePlayerDtoRequestFromJson(json);

  @override
  final int id;
  @override
  final String guid;
  @override
  final String nick;
  @override
  final Device device;

  @override
  String toString() {
    return 'CreatePlayerDtoRequest(id: $id, guid: $guid, nick: $nick, device: $device)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CreatePlayerDtoRequest &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.guid, guid) || other.guid == guid) &&
            (identical(other.nick, nick) || other.nick == nick) &&
            (identical(other.device, device) || other.device == device));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, guid, nick, device);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CreatePlayerDtoRequestCopyWith<_$_CreatePlayerDtoRequest> get copyWith =>
      __$$_CreatePlayerDtoRequestCopyWithImpl<_$_CreatePlayerDtoRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CreatePlayerDtoRequestToJson(
      this,
    );
  }
}

abstract class _CreatePlayerDtoRequest implements CreatePlayerDtoRequest {
  const factory _CreatePlayerDtoRequest(
      {required final int id,
      required final String guid,
      required final String nick,
      required final Device device}) = _$_CreatePlayerDtoRequest;

  factory _CreatePlayerDtoRequest.fromJson(Map<String, dynamic> json) =
      _$_CreatePlayerDtoRequest.fromJson;

  @override
  int get id;
  @override
  String get guid;
  @override
  String get nick;
  @override
  Device get device;
  @override
  @JsonKey(ignore: true)
  _$$_CreatePlayerDtoRequestCopyWith<_$_CreatePlayerDtoRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

CreatePlayerDtoResponse _$CreatePlayerDtoResponseFromJson(
    Map<String, dynamic> json) {
  return _CreatePlayerDtoResponse.fromJson(json);
}

/// @nodoc
mixin _$CreatePlayerDtoResponse {
  int get id => throw _privateConstructorUsedError;
  Team get team => throw _privateConstructorUsedError;
  Position get position => throw _privateConstructorUsedError;
  int get hp => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CreatePlayerDtoResponseCopyWith<CreatePlayerDtoResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreatePlayerDtoResponseCopyWith<$Res> {
  factory $CreatePlayerDtoResponseCopyWith(CreatePlayerDtoResponse value,
          $Res Function(CreatePlayerDtoResponse) then) =
      _$CreatePlayerDtoResponseCopyWithImpl<$Res, CreatePlayerDtoResponse>;
  @useResult
  $Res call({int id, Team team, Position position, int hp});

  $PositionCopyWith<$Res> get position;
}

/// @nodoc
class _$CreatePlayerDtoResponseCopyWithImpl<$Res,
        $Val extends CreatePlayerDtoResponse>
    implements $CreatePlayerDtoResponseCopyWith<$Res> {
  _$CreatePlayerDtoResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? team = null,
    Object? position = null,
    Object? hp = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      team: null == team
          ? _value.team
          : team // ignore: cast_nullable_to_non_nullable
              as Team,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Position,
      hp: null == hp
          ? _value.hp
          : hp // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  @override
  @pragma('vm:prefer-inline')
  $PositionCopyWith<$Res> get position {
    return $PositionCopyWith<$Res>(_value.position, (value) {
      return _then(_value.copyWith(position: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$_CreatePlayerDtoResponseCopyWith<$Res>
    implements $CreatePlayerDtoResponseCopyWith<$Res> {
  factory _$$_CreatePlayerDtoResponseCopyWith(_$_CreatePlayerDtoResponse value,
          $Res Function(_$_CreatePlayerDtoResponse) then) =
      __$$_CreatePlayerDtoResponseCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, Team team, Position position, int hp});

  @override
  $PositionCopyWith<$Res> get position;
}

/// @nodoc
class __$$_CreatePlayerDtoResponseCopyWithImpl<$Res>
    extends _$CreatePlayerDtoResponseCopyWithImpl<$Res,
        _$_CreatePlayerDtoResponse>
    implements _$$_CreatePlayerDtoResponseCopyWith<$Res> {
  __$$_CreatePlayerDtoResponseCopyWithImpl(_$_CreatePlayerDtoResponse _value,
      $Res Function(_$_CreatePlayerDtoResponse) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? team = null,
    Object? position = null,
    Object? hp = null,
  }) {
    return _then(_$_CreatePlayerDtoResponse(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      team: null == team
          ? _value.team
          : team // ignore: cast_nullable_to_non_nullable
              as Team,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as Position,
      hp: null == hp
          ? _value.hp
          : hp // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_CreatePlayerDtoResponse implements _CreatePlayerDtoResponse {
  const _$_CreatePlayerDtoResponse(
      {required this.id,
      required this.team,
      required this.position,
      required this.hp});

  factory _$_CreatePlayerDtoResponse.fromJson(Map<String, dynamic> json) =>
      _$$_CreatePlayerDtoResponseFromJson(json);

  @override
  final int id;
  @override
  final Team team;
  @override
  final Position position;
  @override
  final int hp;

  @override
  String toString() {
    return 'CreatePlayerDtoResponse(id: $id, team: $team, position: $position, hp: $hp)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_CreatePlayerDtoResponse &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.team, team) || other.team == team) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.hp, hp) || other.hp == hp));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, id, team, position, hp);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$_CreatePlayerDtoResponseCopyWith<_$_CreatePlayerDtoResponse>
      get copyWith =>
          __$$_CreatePlayerDtoResponseCopyWithImpl<_$_CreatePlayerDtoResponse>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_CreatePlayerDtoResponseToJson(
      this,
    );
  }
}

abstract class _CreatePlayerDtoResponse implements CreatePlayerDtoResponse {
  const factory _CreatePlayerDtoResponse(
      {required final int id,
      required final Team team,
      required final Position position,
      required final int hp}) = _$_CreatePlayerDtoResponse;

  factory _CreatePlayerDtoResponse.fromJson(Map<String, dynamic> json) =
      _$_CreatePlayerDtoResponse.fromJson;

  @override
  int get id;
  @override
  Team get team;
  @override
  Position get position;
  @override
  int get hp;
  @override
  @JsonKey(ignore: true)
  _$$_CreatePlayerDtoResponseCopyWith<_$_CreatePlayerDtoResponse>
      get copyWith => throw _privateConstructorUsedError;
}
