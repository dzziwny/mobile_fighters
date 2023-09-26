import 'dart:typed_data';

import 'package:vector_math/vector_math.dart';

class Bomb {
  int id;
  Vector2 position;
  Vector2 velocity;
  Vector2 target;

  Bomb({
    required this.id,
    required this.position,
    required this.velocity,
    required this.target,
  });

  factory Bomb.empty(int id) => Bomb(
        id: id,
        position: Vector2.zero(),
        velocity: Vector2.zero(),
        target: Vector2.zero(),
      );

  Uint8List toBytes() {
    final x = (ByteData(2)..setInt16(0, position.x.toInt(), Endian.little))
        .buffer
        .asUint8List();
    final y = (ByteData(2)..setInt16(0, position.y.toInt(), Endian.little))
        .buffer
        .asUint8List();

    final bytes = Uint8List.fromList([...x, ...y]);
    return bytes;
  }
}

class BombView {
  int x;
  int y;

  BombView(this.x, this.y);

  factory BombView.fromBytes(Uint8List bytes) {
    final position = bytes.sublist(0, 4).buffer.asUint16List();
    final x = position[0];
    final y = position[1];
    final instance = BombView(x, y);
    return instance;
  }

  factory BombView.empty(int id) => BombView(0, 0);

  static List<BombView> listFromBytes(Uint8List bytes) {
    final bombs = <BombView>[];

    for (var i = 0; i < bytes.length; i += 4) {
      final chunk = bytes.sublist(i, i + 4);
      final bomb = BombView.fromBytes(chunk);
      bombs.add(bomb);
    }

    return bombs;
  }
}
