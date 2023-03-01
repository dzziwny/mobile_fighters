import 'dart:typed_data';

class AttackResponse {
  final int id;
  final int attackerId;
  final double sourceX;
  final double sourceY;
  final double targetX;
  final double targetY;
  final AttackPhase phase;

  const AttackResponse(
    this.id,
    this.attackerId,
    this.targetX,
    this.targetY,
    this.phase,
    this.sourceX,
    this.sourceY,
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
      ByteData.sublistView(Uint8List.fromList(bytes.sublist(11, 15)))
          .getFloat32(0),
      ByteData.sublistView(Uint8List.fromList(bytes.sublist(15, 19)))
          .getFloat32(0),
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
      ...(ByteData(4)..setFloat32(0, sourceX)).buffer.asUint8List(),
      ...(ByteData(4)..setFloat32(0, sourceY)).buffer.asUint8List(),
    ];

    return bytes;
  }
}

enum AttackPhase {
  start,
  boom,
}
