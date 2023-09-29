import 'dart:typed_data';

import 'package:core/src/constants.dart';
import 'package:vector_math/vector_math.dart';

import 'ammunition.dart';

class Bomb implements Ammunition {
  int id;
  @override
  int shooterId;
  @override
  double angle;
  @override
  Vector2 startPosition;
  @override
  Vector2 position;
  @override
  Vector2 velocity;
  bool isActive;

  Bomb({
    required this.id,
    required this.shooterId,
    required this.angle,
    required this.position,
    required this.velocity,
    required this.isActive,
  }) : startPosition = position;

  factory Bomb.empty(int id) => Bomb(
        id: id,
        shooterId: 0,
        angle: 0.0,
        position: Vector2.zero(),
        velocity: Vector2.zero(),
        isActive: false,
      );

  Uint8List toBytes() {
    final x = (ByteData(2)..setInt16(0, position.x.toInt(), Endian.little))
        .buffer
        .asUint8List();
    final y = (ByteData(2)..setInt16(0, position.y.toInt(), Endian.little))
        .buffer
        .asUint8List();

    final isActive = this.isActive ? 1 : 0;

    final bytes = Uint8List.fromList([...x, ...y, isActive]);
    return bytes;
  }

  static int bytesCount = Bomb.empty(0).toBytes().length;
  static int allBytesCount = bytesCount * maxBombs;
}

class BombView {
  int x;
  int y;
  bool isActive;

  BombView(this.x, this.y, this.isActive);

  factory BombView.fromBytes(Uint8List bytes) {
    final position = bytes.sublist(0, 4).buffer.asUint16List();
    final x = position[0];
    final y = position[1];
    final isActive = bytes[4] == 1;
    final instance = BombView(x, y, isActive);
    return instance;
  }

  factory BombView.empty(int id) => BombView(0, 0, false);

  static List<BombView> listFromBytes(Uint8List bytes) {
    final bombs = <BombView>[];

    for (var i = 0; i < bytes.length; i += Bomb.bytesCount) {
      final chunk = bytes.sublist(i, i + Bomb.bytesCount);
      final bomb = BombView.fromBytes(chunk);
      bombs.add(bomb);
    }

    return bombs;
  }
}

extension BombsToBytes on List<Bomb> {
  Uint8List toBytes() {
    final builder = BytesBuilder();
    for (var bullet in this) {
      builder.add(bullet.toBytes());
    }

    return builder.toBytes();
  }
}
