import 'dart:typed_data';

import 'package:core/src/extensions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_position.freezed.dart';
part 'player_position.g.dart';

@freezed
class PlayerPosition with _$PlayerPosition {
  const factory PlayerPosition({
    required int playerId,
    required double x,
    required double y,
    required double angle,
  }) = _PlayerPosition;

  factory PlayerPosition.fromJson(Map<String, dynamic> json) =>
      _$PlayerPositionFromJson(json);

  @override
  String toString() {
    return "player position: [id: $playerId, x: $x, y: $y, angle: $angle]";
  }

  factory PlayerPosition.fromBytes(Uint8List bytes) => PlayerPosition(
        playerId: bytes[0],
        x: bytes.toDouble(1, 5),
        y: bytes.toDouble(5, 9),
        angle: bytes.toDouble(9, 13),
      );
}
