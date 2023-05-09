import 'dart:typed_data';

import 'package:core/src/extensions.dart';

class BulletResponse {
  final int id;
  final double x;
  final double y;
  final double angle;
  final bool isRemoved;

  const BulletResponse(
    this.id,
    this.x,
    this.y,
    this.angle,
    this.isRemoved,
  );

  static Uint8List bytes(
    int id,
    double x,
    double y,
    double angle,
    bool isRemoved,
  ) =>
      [
        id,
        ...x.toBytes(),
        ...y.toBytes(),
        ...angle.toBytes(),
        isRemoved ? 1 : 0,
      ].toBytes();

  factory BulletResponse.fromBytes(Uint8List bytes) {
    final instance = BulletResponse(
      bytes[0],
      bytes.toDouble(1, 5),
      bytes.toDouble(5, 9),
      bytes.toDouble(9, 13),
      bytes[13] == 1,
    );

    return instance;
  }

  Uint8List toBytes() {
    final bytes = <int>[
      id,
      ...x.toBytes(),
      ...y.toBytes(),
      ...angle.toBytes(),
      isRemoved ? 1 : 0,
    ].toBytes();

    return bytes;
  }
}

class BulletRequest {
  static Uint8List stopGun = [0].toBytes();
  static Uint8List startGun = [1].toBytes();
  static Uint8List reloadGun = [2].toBytes();
}
