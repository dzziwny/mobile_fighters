import 'dart:typed_data';

class AttackResponse {
  final int id;
  final int attackerId;
  final double targetX;
  final double targetY;
  final AttackPhase phase;

  const AttackResponse(
    this.id,
    this.attackerId,
    this.targetX,
    this.targetY,
    this.phase,
  );

  factory AttackResponse.fromBytes(List<int> bytes) {
    final instance = AttackResponse(
      bytes[0],
      bytes[1],
      ByteData.sublistView(Uint8List.fromList(bytes.sublist(2, 6)))
          .getFloat32(0),
      ByteData.sublistView(Uint8List.fromList(bytes.sublist(6, 10)))
          .getFloat32(0),
      AttackPhase.values[bytes[10]],
    );

    return instance;
  }

  List<int> toBytes() {
    final bytes = <int>[
      id,
      attackerId,
      ...(ByteData(4)..setFloat32(0, targetX)).buffer.asUint8List(),
      ...(ByteData(4)..setFloat32(0, targetY)).buffer.asUint8List(),
      phase.index,
    ];

    return bytes;
  }
}

enum AttackPhase {
  start,
  boom,
}
