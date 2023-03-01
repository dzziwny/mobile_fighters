import 'dart:typed_data';

class HitDto {
  final int playerId;
  final int hp;

  const HitDto({
    required this.playerId,
    required this.hp,
  });

  factory HitDto.fromBytes(Uint8List bytes) =>
      HitDto(playerId: bytes[0], hp: bytes[1]);
}
