import 'dart:typed_data';

import 'package:core/src/extensions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_angle.freezed.dart';
part 'player_angle.g.dart';

@freezed
class PlayerAngle with _$PlayerAngle {
  const factory PlayerAngle({
    required double angle,
  }) = _PlayerAngle;

  factory PlayerAngle.fromJson(Map<String, dynamic> json) =>
      _$PlayerAngleFromJson(json);

  @override
  String toString() {
    return "player angle: [angle: $angle]";
  }

  factory PlayerAngle.fromBytes(Uint8List bytes) => PlayerAngle(
        angle: bytes.toDouble(0, 4),
      );

  static Uint8List toBytes(double angle) => angle.toBytes();
}
