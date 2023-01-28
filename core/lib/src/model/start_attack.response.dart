import 'dart:typed_data';

class StartAttackResponse {
  final int attackerId;
  final double targetX;
  final double targetY;

  const StartAttackResponse(
    this.attackerId,
    this.targetX,
    this.targetY,
  );

  factory StartAttackResponse.fromBytes(dynamic data) {
    List<int> bytes = data;
    final instance = StartAttackResponse(
      bytes[0],
      ByteData.sublistView(Uint8List.fromList(bytes.sublist(1, 5)))
          .getFloat32(0),
      ByteData.sublistView(Uint8List.fromList(bytes.sublist(5, 9)))
          .getFloat32(0),
    );

    return instance;
  }

  List<int> toBytes() {
    final bytes = <int>[
      attackerId,
      ...(ByteData(4)..setFloat32(0, targetX)).buffer.asUint8List(),
      ...(ByteData(4)..setFloat32(0, targetY)).buffer.asUint8List(),
    ];

    return bytes;
  }
}
