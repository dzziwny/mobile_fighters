// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'get_players.dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

GetPlayersDtoResponse _$GetPlayersDtoResponseFromJson(
    Map<String, dynamic> json) {
  return _GetPlayersDtoResponse.fromJson(json);
}

/// @nodoc
mixin _$GetPlayersDtoResponse {
  Map<int, int> get players => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $GetPlayersDtoResponseCopyWith<GetPlayersDtoResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GetPlayersDtoResponseCopyWith<$Res> {
  factory $GetPlayersDtoResponseCopyWith(GetPlayersDtoResponse value,
          $Res Function(GetPlayersDtoResponse) then) =
      _$GetPlayersDtoResponseCopyWithImpl<$Res>;
  $Res call({Map<int, int> players});
}

/// @nodoc
class _$GetPlayersDtoResponseCopyWithImpl<$Res>
    implements $GetPlayersDtoResponseCopyWith<$Res> {
  _$GetPlayersDtoResponseCopyWithImpl(this._value, this._then);

  final GetPlayersDtoResponse _value;
  // ignore: unused_field
  final $Res Function(GetPlayersDtoResponse) _then;

  @override
  $Res call({
    Object? players = freezed,
  }) {
    return _then(_value.copyWith(
      players: players == freezed
          ? _value.players
          : players // ignore: cast_nullable_to_non_nullable
              as Map<int, int>,
    ));
  }
}

/// @nodoc
abstract class _$$_GetPlayersDtoResponseCopyWith<$Res>
    implements $GetPlayersDtoResponseCopyWith<$Res> {
  factory _$$_GetPlayersDtoResponseCopyWith(_$_GetPlayersDtoResponse value,
          $Res Function(_$_GetPlayersDtoResponse) then) =
      __$$_GetPlayersDtoResponseCopyWithImpl<$Res>;
  @override
  $Res call({Map<int, int> players});
}

/// @nodoc
class __$$_GetPlayersDtoResponseCopyWithImpl<$Res>
    extends _$GetPlayersDtoResponseCopyWithImpl<$Res>
    implements _$$_GetPlayersDtoResponseCopyWith<$Res> {
  __$$_GetPlayersDtoResponseCopyWithImpl(_$_GetPlayersDtoResponse _value,
      $Res Function(_$_GetPlayersDtoResponse) _then)
      : super(_value, (v) => _then(v as _$_GetPlayersDtoResponse));

  @override
  _$_GetPlayersDtoResponse get _value =>
      super._value as _$_GetPlayersDtoResponse;

  @override
  $Res call({
    Object? players = freezed,
  }) {
    return _then(_$_GetPlayersDtoResponse(
      players: players == freezed
          ? _value._players
          : players // ignore: cast_nullable_to_non_nullable
              as Map<int, int>,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_GetPlayersDtoResponse implements _GetPlayersDtoResponse {
  const _$_GetPlayersDtoResponse({required final Map<int, int> players})
      : _players = players;

  factory _$_GetPlayersDtoResponse.fromJson(Map<String, dynamic> json) =>
      _$$_GetPlayersDtoResponseFromJson(json);

  final Map<int, int> _players;
  @override
  Map<int, int> get players {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_players);
  }

  @override
  String toString() {
    return 'GetPlayersDtoResponse(players: $players)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_GetPlayersDtoResponse &&
            const DeepCollectionEquality().equals(other._players, _players));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_players));

  @JsonKey(ignore: true)
  @override
  _$$_GetPlayersDtoResponseCopyWith<_$_GetPlayersDtoResponse> get copyWith =>
      __$$_GetPlayersDtoResponseCopyWithImpl<_$_GetPlayersDtoResponse>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_GetPlayersDtoResponseToJson(
      this,
    );
  }
}

abstract class _GetPlayersDtoResponse implements GetPlayersDtoResponse {
  const factory _GetPlayersDtoResponse({required final Map<int, int> players}) =
      _$_GetPlayersDtoResponse;

  factory _GetPlayersDtoResponse.fromJson(Map<String, dynamic> json) =
      _$_GetPlayersDtoResponse.fromJson;

  @override
  Map<int, int> get players;
  @override
  @JsonKey(ignore: true)
  _$$_GetPlayersDtoResponseCopyWith<_$_GetPlayersDtoResponse> get copyWith =>
      throw _privateConstructorUsedError;
}
