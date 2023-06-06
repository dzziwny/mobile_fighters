import 'dart:math';

import 'package:core/core.dart';
import 'package:synchronized/synchronized.dart';
import 'package:vector_math/vector_math.dart';

import '../setup.dart';

var _bulletIdLock = Lock();
final _bits = List<int>.generate(256, (i) => i);
final _idsInUsage = <int, bool>{};

Future<int> _generateAttackId() => _bulletIdLock.synchronized(() {
      for (var id in _bits) {
        if (_idsInUsage[id] != null) {
          continue;
        }

        _idsInUsage[id] = true;
        return id;
      }

      throw Exception('Bullet stack overflow xd');
    });

Future<void> _releaseAttackId(int id) => _bulletIdLock.synchronized(() {
      _idsInUsage.remove(id);
    });

Future<void> createBulletUpdate(int playerId) async {
  final physic = playerPhysics[playerId];
  if (physic == null) {
    return;
  }

  final id = await _generateAttackId();
  final velocity =
      Vector2(sin(physic.angle), -cos(physic.angle)).normalized() * 2000;
  final bullet = Bullet(
    id: id,
    shooter: playerId,
    velocity: velocity,
    angle: physic.angle,
    position: physic.position,
  );

  bullets[id] = bullet;
}

Future<void> bulletPhysicUpdate(Bullet bullet, double dt) async {
  final position = bullet.position + bullet.velocity * dt;
  if (position.x < 0.0 ||
      position.x > boardWidth ||
      position.y < 0.0 ||
      position.y > boardHeight) {
    return await _removeBullet(bullet);
  }

  bullet.position = position;
}

Future<void> _removeBullet(Bullet bullet) async {
  await _releaseAttackId(bullet.id);
  bullets.remove(bullet.id);
}
