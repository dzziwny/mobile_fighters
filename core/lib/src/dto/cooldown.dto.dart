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

  factory CooldownDto.fromBytes(List<int> data) => CooldownDto(
        cooldownType: CooldownType.values[data[0]],
        isCooldown: data[1] == 1,
      );

  List<int> toData() {
    return [
      cooldownType.index,
      isCooldown ? 1 : 0,
    ];
  }
}
