import 'dart:async';

import 'package:bubble_fight/di.dart';
import 'package:core/core.dart';

class CooldownService {
  final _attackCooldown = cooldownWs
      .data()
      .where((dto) => dto.cooldownType == CooldownType.attack)
      .map((dto) => dto.isCooldown);

  final _dashCooldown = cooldownWs
      .data()
      .where((dto) => dto.cooldownType == CooldownType.dash)
      .map((dto) => dto.isCooldown);

  Stream<bool> attack() => _attackCooldown.asBroadcastStream();
  Stream<bool> dash() => _dashCooldown.asBroadcastStream();
}
