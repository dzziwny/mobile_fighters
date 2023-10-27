import 'dart:typed_data';

import 'package:core/src/constants.dart';
import 'package:core/src/extensions.dart';
import 'package:vector_math/vector_math.dart';

import 'ammunition.dart';

class BulletViewModel {
  Vector2 position;
  double angle;

  BulletViewModel({
    required this.position,
    required this.angle,
  });

  factory BulletViewModel.empty() => BulletViewModel(
        angle: 0.0,
        position: resetPosition,
      );

  static int bytesCount = BulletViewModel.empty().toBytes().length;
  static int allBytesCount = bytesCount * maxBullets;

  Uint8List toBytes() {
    final bytes = <int>[
      ...position.x.toBytes(),
      ...position.y.toBytes(),
      ...angle.toBytes(),
    ].toBytes();

    return bytes;
  }

  static List<BulletViewModel> manyFromBytes(Uint8List bytes) {
    final bullets = <BulletViewModel>[];

    for (var i = 0; i < bytes.length; i += bytesCount) {
      final chunk = bytes.sublist(i, i + bytesCount);
      final response = BulletViewModel.fromBytes(chunk);
      bullets.add(response);
    }

    return bullets;
  }

  factory BulletViewModel.fromBytes(Uint8List bytes) {
    final instance = BulletViewModel(
      position: Vector2(bytes.toDouble(0, 4), bytes.toDouble(4, 8)),
      angle: bytes.toDouble(8, 12),
    );

    return instance;
  }
}

class Bullet extends BulletViewModel implements Ammunition {
  final int id;

  @override
  int shooterId;

  @override
  Vector2 velocity;
  @override
  Vector2 startPosition;

  Bullet({
    required super.angle,
    required super.position,
    required this.id,
    required this.shooterId,
    required this.velocity,
  }) : startPosition = position;

  factory Bullet.empty(int id) {
    return Bullet(
      id: id,
      shooterId: 0,
      velocity: Vector2.zero(),
      angle: 0.0,
      position: resetPosition,
    );
  }

  static int bytesCount = Bullet.empty(0).toBytes().length * maxBullets;

  @override
  void reset() {
    position = resetPosition;
    velocity = Vector2.zero();
  }
}

extension BulletsToBytes on List<Bullet> {
  Uint8List toBytes() {
    final builder = BytesBuilder();
    for (var bullet in this) {
      builder.add(bullet.toBytes());
    }

    return builder.toBytes();
  }
}
