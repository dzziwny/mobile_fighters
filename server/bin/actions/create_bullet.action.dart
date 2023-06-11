import 'dart:math';

import 'package:core/core.dart';
import 'package:synchronized/synchronized.dart';
import 'package:vector_math/vector_math.dart';

import '../setup.dart';
import 'action.dart';

var _bulletIdLock = Lock();
final _bits = List<int>.generate(256, (i) => i);
final _idsInUsage = <int, bool>{};

Future<int> _generateBulletId() => _bulletIdLock.synchronized(
      () {
        for (var id in _bits) {
          if (_idsInUsage[id] != null) {
            continue;
          }

          _idsInUsage[id] = true;
          return id;
        }

        throw Exception('Bullet stack overflow xd');
      },
    );

Future<void> releaseBulletId(int id) => _bulletIdLock.synchronized(
      () {
        _idsInUsage.remove(id);
      },
    );

class CreateBulletAction implements Action {
  const CreateBulletAction(this.playerId);

  final int playerId;

  @override
  Future<void> handle() async {
    final physic = playerPhysics[playerId];
    if (physic == null) {
      return;
    }

    final id = await _generateBulletId();
    final velocity = Vector2(sin(physic.angle), -cos(physic.angle)).normalized()
      ..scale(2000);

    final bullet = Bullet(
      id: id,
      shooterId: playerId,
      velocity: velocity,
      angle: physic.angle,
      position: physic.position,
    );

    bullets[id] = bullet;
  }
}
