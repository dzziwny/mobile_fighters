import 'dart:typed_data';

class DashDto {
  final int playerId;
  final bool isDash;

  const DashDto(this.playerId, this.isDash);

  factory DashDto.fromBytes(Uint8List bytes) =>
      DashDto(bytes[0], bytes[1] == 1);
}
