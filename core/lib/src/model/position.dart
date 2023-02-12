import 'dart:typed_data';

class Position {
  final int playerId;
  final double x;
  final double y;
  final double angle;

  const Position(this.playerId, this.x, this.y, this.angle);

  @override
  String toString() {
    return "position: [id: $playerId, x: $x, y: $y, angle: $angle]";
  }

  factory Position.fromBytes(List<int> bytes) => Position(
        bytes[0],
        ByteData.sublistView(Uint8List.fromList(bytes.sublist(1, 5)))
            .getFloat32(0),
        ByteData.sublistView(Uint8List.fromList(bytes.sublist(5, 9)))
            .getFloat32(0),
        ByteData.sublistView(Uint8List.fromList(bytes.sublist(9, 13)))
            .getFloat32(0),
      );
}
