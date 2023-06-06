import 'dart:typed_data';

import 'package:core/src/extensions.dart';

import '../dto/hit.dto.dart';
import 'bomb_attack.response.dart';
import 'bullet.dart';
import 'bullet.response.dart';
import 'player_physics.dart';
import 'player_position.dart';

class GameState {
  final List<PlayerPosition> positions;
  final List<BombAttackResponse> bombs;
  final List<HitDto> hits;
  final List<BulletResponse> bullets;

  GameState(
    this.positions,
    this.bombs,
    this.hits,
    this.bullets,
  );

  factory GameState.fromBytes(Uint8List bytes) {
    final positionsLength = bytes[0];
    final positionsBytesLength = positionsLength * 13;
    final positionsBytes = bytes.sublist(1, 1 + positionsBytesLength);
    final positions = PlayerPosition.positionsFromBytes(positionsBytes);

    var leftBytes = bytes.sublist(1 + positionsBytesLength);
    final bombsLenght = leftBytes[0];
    final bombsBytesLength = bombsLenght * 19;
    final bombsBytes = leftBytes.sublist(1, 1 + bombsBytesLength);
    final bombs = BombAttackResponse.attacksFromBytes(bombsBytes);

    leftBytes = leftBytes.sublist(1 + bombsBytesLength);
    final hitsLenght = leftBytes[0];
    final hitsBytesLength = hitsLenght * 2;
    final hitsBytes = leftBytes.sublist(1, 1 + hitsBytesLength);
    final hits = HitDto.hitsFromBytes(hitsBytes);

    leftBytes = leftBytes.sublist(1 + hitsBytesLength);
    final bulletsLenght = leftBytes[0];
    final bulletsBytesLength = bulletsLenght * 14;
    final bulletsBytes = leftBytes.sublist(1, 1 + bulletsBytesLength);
    final bullets = BulletResponse.bulletsFromBytes(bulletsBytes);

    return GameState(positions, bombs, hits, bullets);
  }

  static Uint8List bytes(
    Iterable<MapEntry<int, PlayerPhysics>> pushes,
    List<BombAttackResponse> bombs,
    List<HitDto> hits,
    Iterable<Bullet> bullets,
  ) {
    final pushBytes = <int>[];
    for (var push in pushes) {
      final bytes = <int>[
        push.key,
        ...push.value.position.x.toBytes(),
        ...push.value.position.y.toBytes(),
        ...push.value.angle.toBytes(),
      ];

      pushBytes.addAll(bytes);
    }

    final bombsBytes = <int>[];
    for (var attack in bombs) {
      final bytes = attack.toBytes();
      bombsBytes.addAll(bytes);
    }

    final hitsBytes = <int>[];
    for (var hit in hits) {
      final bytes = hit.toBytes();
      hitsBytes.addAll(bytes);
    }

    final bulletsBytes = <int>[];
    for (var bullet in bullets) {
      final bytes = BulletResponse.bytes(
        bullet.id,
        bullet.position.x,
        bullet.position.y,
        bullet.angle,
        false,
      );

      bulletsBytes.addAll(bytes);
    }

    final bytes = <int>[
      pushes.length,
      ...pushBytes,
      bombs.length,
      ...bombsBytes,
      hits.length,
      ...hitsBytes,
      bullets.length,
      ...bulletsBytes,
    ];

    return Uint8List.fromList(bytes);
  }
}
