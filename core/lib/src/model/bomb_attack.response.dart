import 'dart:typed_data';

import 'package:core/core.dart';

class BombAttackResponse {
  final int id;
  final int attackerId;
  final double sourceX;
  final double sourceY;
  final double targetX;
  final double targetY;
  final AttackPhase phase;

  const BombAttackResponse(
    this.id,
    this.attackerId,
    this.targetX,
    this.targetY,
    this.phase,
    this.sourceX,
    this.sourceY,
  );

  factory BombAttackResponse.fromBytes(Uint8List bytes) {
    final instance = BombAttackResponse(
      bytes[0],
      bytes[1],
      bytes.toDouble(2, 6),
      bytes.toDouble(6, 10),
      AttackPhase.values[bytes[10]],
      bytes.toDouble(11, 15),
      bytes.toDouble(15, 19),
    );

    return instance;
  }

  Uint8List toBytes() {
    final bytes = <int>[
      id,
      attackerId,
      ...targetX.toBytes(),
      ...targetY.toBytes(),
      phase.index,
      ...sourceX.toBytes(),
      ...sourceY.toBytes(),
    ].toBytes();

    return bytes;
  }
}

enum AttackPhase {
  start,
  boom,
}

class AttackRequest {
  static Uint8List bomb = [0].toBytes();
}
