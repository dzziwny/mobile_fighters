import 'dart:typed_data';

import 'package:core/core.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'position.freezed.dart';
part 'position.g.dart';

@freezed
class Position with _$Position {
  const factory Position({
    required int playerId,
    required double x,
    required double y,
    required double angle,
  }) = _Position;

  factory Position.fromJson(Map<String, dynamic> json) =>
      _$PositionFromJson(json);

  @override
  String toString() {
    return "position: [id: $playerId, x: $x, y: $y, angle: $angle]";
  }

  factory Position.fromBytes(Uint8List bytes) => Position(
        playerId: bytes[0],
        x: bytes.toDouble(1, 5),
        y: bytes.toDouble(5, 9),
        angle: bytes.toDouble(9, 13),
      );
}
