import 'dart:typed_data';

import 'package:core/src/extensions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'position.freezed.dart';
part 'position.g.dart';

@freezed
class Position with _$Position {
  const factory Position({
    required double x,
    required double y,
    required double angle,
  }) = _Position;

  factory Position.fromJson(Map<String, dynamic> json) =>
      _$PositionFromJson(json);

  @override
  String toString() {
    return "position: [x: $x, y: $y, angle: $angle]";
  }

  factory Position.fromBytes(Uint8List bytes) => Position(
        x: bytes.toDouble(1, 5),
        y: bytes.toDouble(5, 9),
        angle: bytes.toDouble(9, 13),
      );
}
