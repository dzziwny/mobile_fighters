import 'dart:typed_data';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'movement_keyboard.freezed.dart';
part 'movement_keyboard.g.dart';

@freezed
class MovementKeyboard with _$MovementKeyboard {
  const factory MovementKeyboard({
    // 0xWSAD
    required int keys,
  }) = _MovementKeyboard;

  factory MovementKeyboard.fromJson(Map<String, dynamic> json) =>
      _$MovementKeyboardFromJson(json);

  @override
  String toString() {
    return "keys: $keys";
  }

  factory MovementKeyboard.fromBytes(Uint8List bytes) => MovementKeyboard(
        keys: bytes[0],
      );
}
