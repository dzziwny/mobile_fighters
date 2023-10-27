// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

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
  String get guid => throw _privateConstructorUsedError;
  int get id => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $LeaveGameDtoRequestCopyWith<LeaveGameDtoRequest> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LeaveGameDtoRequestCopyWith<$Res> {
  factory $LeaveGameDtoRequestCopyWith(
          LeaveGameDtoRequest value, $Res Function(LeaveGameDtoRequest) then) =
      _$LeaveGameDtoRequestCopyWithImpl<$Res, LeaveGameDtoRequest>;
  @useResult
  $Res call({String guid, int id});
}

/// @nodoc
class _$LeaveGameDtoRequestCopyWithImpl<$Res, $Val extends LeaveGameDtoRequest>
    implements $LeaveGameDtoRequestCopyWith<$Res> {
  _$LeaveGameDtoRequestCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? guid = null,
    Object? id = null,
  }) {
    return _then(_value.copyWith(
      guid: null == guid
          ? _value.guid
          : guid // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$_LeaveGameDtoRequestCopyWith<$Res>
    implements $LeaveGameDtoRequestCopyWith<$Res> {
  factory _$$_LeaveGameDtoRequestCopyWith(_$_LeaveGameDtoRequest value,
          $Res Function(_$_LeaveGameDtoRequest) then) =
      __$$_LeaveGameDtoRequestCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String guid, int id});
}

/// @nodoc
class __$$_LeaveGameDtoRequestCopyWithImpl<$Res>
    extends _$LeaveGameDtoRequestCopyWithImpl<$Res, _$_LeaveGameDtoRequest>
    implements _$$_LeaveGameDtoRequestCopyWith<$Res> {
  __$$_LeaveGameDtoRequestCopyWithImpl(_$_LeaveGameDtoRequest _value,
      $Res Function(_$_LeaveGameDtoRequest) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? guid = null,
    Object? id = null,
  }) {
    return _then(_$_LeaveGameDtoRequest(
      guid: null == guid
          ? _value.guid
          : guid // ignore: cast_nullable_to_non_nullable
              as String,
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_LeaveGameDtoRequest implements _LeaveGameDtoRequest {
  const _$_LeaveGameDtoRequest({required this.guid, required this.id});

  factory _$_LeaveGameDtoRequest.fromJson(Map<String, dynamic> json) =>
      _$$_LeaveGameDtoRequestFromJson(json);

  @override
  final String guid;
  @override
  final int id;

  @override
  String toString() {
    return 'LeaveGameDtoRequest(guid: $guid, id: $id)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_LeaveGameDtoRequest &&
            (identical(other.guid, guid) || other.guid == guid) &&
            (identical(other.id, id) || other.id == id));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, guid, id);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
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
  const factory _LeaveGameDtoRequest(
      {required final String guid,
      required final int id}) = _$_LeaveGameDtoRequest;

  factory _LeaveGameDtoRequest.fromJson(Map<String, dynamic> json) =
      _$_LeaveGameDtoRequest.fromJson;

  @override
  String get guid;
  @override
  int get id;
  @override
  @JsonKey(ignore: true)
  _$$_LeaveGameDtoRequestCopyWith<_$_LeaveGameDtoRequest> get copyWith =>
      throw _privateConstructorUsedError;
}
