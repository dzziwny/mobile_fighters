import 'dart:typed_data';

import 'package:core/core.dart';

enum CooldownType {
  dash,
  attack,
}

class CooldownDto {
  final bool isCooldown;
  final CooldownType cooldownType;

  const CooldownDto({
    required this.isCooldown,
    required this.cooldownType,
  });

  factory CooldownDto.fromBytes(Uint8List data) => CooldownDto(
        cooldownType: CooldownType.values[data[0]],
        isCooldown: data[1] == 1,
      );

  Uint8List toBytes() {
    return [
      cooldownType.index,
      isCooldown ? 1 : 0,
    ].toBytes();
  }
}
