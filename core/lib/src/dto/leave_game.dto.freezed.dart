// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'leave_game.dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

LeaveGameDtoRequest _$LeaveGameDtoRequestFromJson(Map<String, dynamic> json) {
  return _LeaveGameDtoRequest.fromJson(json);
}

/// @nodoc
mixin _$LeaveGameDtoRequest {
  int get guid => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LeaveGameDtoRequestCopyWith<LeaveGameDtoRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeaveGameDtoRequestCopyWith<$Res> {
  factory $LeaveGameDtoRequestCopyWith(
          LeaveGameDtoRequest value, $Res Function(LeaveGameDtoRequest) then) =
      _$LeaveGameDtoRequestCopyWithImpl<$Res>;
  $Res call({int guid});
}

/// @nodoc
class _$LeaveGameDtoRequestCopyWithImpl<$Res>
    implements $LeaveGameDtoRequestCopyWith<$Res> {
  _$LeaveGameDtoRequestCopyWithImpl(this._value, this._then);

  final LeaveGameDtoRequest _value;
  // ignore: unused_field
  final $Res Function(LeaveGameDtoRequest) _then;

  @override
  $Res call({
    Object? guid = freezed,
  }) {
    return _then(_value.copyWith(
      guid: guid == freezed
          ? _value.guid
          : guid // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
abstract class _$$_LeaveGameDtoRequestCopyWith<$Res>
    implements $LeaveGameDtoRequestCopyWith<$Res> {
  factory _$$_LeaveGameDtoRequestCopyWith(_$_LeaveGameDtoRequest value,
          $Res Function(_$_LeaveGameDtoRequest) then) =
      __$$_LeaveGameDtoRequestCopyWithImpl<$Res>;
  @override
  $Res call({int guid});
}

/// @nodoc
class __$$_LeaveGameDtoRequestCopyWithImpl<$Res>
    extends _$LeaveGameDtoRequestCopyWithImpl<$Res>
    implements _$$_LeaveGameDtoRequestCopyWith<$Res> {
  __$$_LeaveGameDtoRequestCopyWithImpl(_$_LeaveGameDtoRequest _value,
      $Res Function(_$_LeaveGameDtoRequest) _then)
      : super(_value, (v) => _then(v as _$_LeaveGameDtoRequest));

  @override
  _$_LeaveGameDtoRequest get _value => super._value as _$_LeaveGameDtoRequest;

  @override
  $Res call({
    Object? guid = freezed,
  }) {
    return _then(_$_LeaveGameDtoRequest(
      guid: guid == freezed
          ? _value.guid
          : guid // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_LeaveGameDtoRequest implements _LeaveGameDtoRequest {
  const _$_LeaveGameDtoRequest({required this.guid});

  factory _$_LeaveGameDtoRequest.fromJson(Map<String, dynamic> json) =>
      _$$_LeaveGameDtoRequestFromJson(json);

  @override
  final int guid;

  @override
  String toString() {
    return 'LeaveGameDtoRequest(guid: $guid)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LeaveGameDtoRequest &&
            const DeepCollectionEquality().equals(other.guid, guid));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(guid));

  @JsonKey(ignore: true)
  @override
  _$$_LeaveGameDtoRequestCopyWith<_$_LeaveGameDtoRequest> get copyWith =>
      __$$_LeaveGameDtoRequestCopyWithImpl<_$_LeaveGameDtoRequest>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_LeaveGameDtoRequestToJson(
      this,
    );
  }
}

abstract class _LeaveGameDtoRequest implements LeaveGameDtoRequest {
  const factory _LeaveGameDtoRequest({required final int guid}) =
      _$_LeaveGameDtoRequest;

  factory _LeaveGameDtoRequest.fromJson(Map<String, dynamic> json) =
      _$_LeaveGameDtoRequest.fromJson;

  @override
  int get guid;
  @override
  @JsonKey(ignore: true)
  _$$_LeaveGameDtoRequestCopyWith<_$_LeaveGameDtoRequest> get copyWith =>
      throw _privateConstructorUsedError;
}
