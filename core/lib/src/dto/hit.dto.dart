import 'dart:typed_data';

import 'package:core/core.dart';

class HitDto {
  int playerId;
  double hp;

  HitDto({
    required this.playerId,
    required this.hp,
  });

  factory HitDto.fromBytes(Uint8List bytes) =>
      HitDto(playerId: bytes[0], hp: bytes[1].toDouble());

  factory HitDto.empty(int id) => HitDto(
        playerId: id,
        hp: gameSettings.startHp,
      );

  static List<HitDto> hitsFromBytes(Uint8List bytes) {
    final hits = <HitDto>[];

    for (var i = 0; i < bytes.length; i += 2) {
      final chunk = bytes.sublist(i, i + 2);
      final hit = HitDto.fromBytes(chunk);
      hits.add(hit);
    }

    return hits;
  }

  Uint8List toBytes() => [playerId, hp.toInt()].toBytes();
}
