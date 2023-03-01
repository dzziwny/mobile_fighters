import 'dart:typed_data';

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

  factory Position.fromBytes(List<int> bytes) => Position(
        playerId: bytes[0],
        x: ByteData.sublistView(Uint8List.fromList(bytes.sublist(1, 5)))
            .getFloat32(0),
        y: ByteData.sublistView(Uint8List.fromList(bytes.sublist(5, 9)))
            .getFloat32(0),
        angle: ByteData.sublistView(Uint8List.fromList(bytes.sublist(9, 13)))
            .getFloat32(0),
      );
}
