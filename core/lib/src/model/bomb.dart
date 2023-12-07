import 'dart:typed_data';

import 'package:core/src/game_settings.dart';
import 'package:vector_math/vector_math.dart';

import 'ammunition.dart';

class Bomb extends Ammunition {
  int id;

  Bomb({
    required this.id,
    required super.shooterId,
    required super.angle,
    required super.position,
    required super.velocity,
  }) : super(startPosition: position);

  factory Bomb.empty(int id) => Bomb(
        id: id,
        shooterId: 0,
        angle: 0.0,
        position: gameSettings.resetPosition(),
        velocity: Vector2.zero(),
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

  static int bytesCount = Bomb.empty(0).toBytes().length;
  static int allBytesCount = bytesCount * gameSettings.maxBombs;
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

  factory BombView.empty(int id) => BombView(
        gameSettings.battleGroundEndXInt,
        gameSettings.battleGroundEndYInt,
      );

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
