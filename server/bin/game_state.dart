import 'package:core/core.dart';

import 'setup.dart';

class GameState {
  final List<int> pushChannelDatas;
  final List<List<int>> attackWSChannelsDatas;
  final List<List<int>> hitWSChannelsDatas;
  final List<int> bulletWSChannelsDatas;

  GameState(
    this.pushChannelDatas,
    this.attackWSChannelsDatas,
    this.hitWSChannelsDatas,
    this.bulletWSChannelsDatas,
  );

  factory GameState.create() {
    final pushChannelDatas = <int>[];
    for (var entry in playerPhysics.entries) {
      final data = <int>[
        entry.key,
        ...entry.value.position.x.toBytes(),
        ...entry.value.position.y.toBytes(),
        ...entry.value.angle.toBytes(),
      ];

      pushChannelDatas.addAll(data);
    }

    final attackWSChannelsDatas = bombAttackResponses.map(
      (response) {
        return response.toBytes();
      },
    ).toList();
    bombAttackResponses = [];

    final hitWSChannelsDatas = hits.map(
      (response) {
        return response.toBytes();
      },
    ).toList();
    hits = [];

    final bulletWSChannelsDatas = <int>[];
    for (var bullet in bullets.values) {
      final data = BulletResponse.bytes(
        bullet.id,
        bullet.position.x,
        bullet.position.y,
        bullet.angle,
        false,
      );

      bulletWSChannelsDatas.addAll(data);
    }

    return GameState(
      pushChannelDatas,
      attackWSChannelsDatas,
      hitWSChannelsDatas,
      bulletWSChannelsDatas,
    );
  }
}
