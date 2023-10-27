import 'dart:typed_data';

import 'package:core/src/constants.dart';

import 'bomb.dart';
import 'bullet.dart';
import 'player.dart';

class GameState {
  final List<PlayerViewModel> players;
  final List<BombView> bombs;
  final List<int> hits;
  final List<BulletViewModel> bullets;

  factory GameState.empty() => GameState(
        List.generate(maxPlayers, PlayerViewModel.empty),
        List.generate(maxBombs, BombView.empty),
        List.filled(maxPlayers, 0),
        List.generate(maxBullets, Bullet.empty),
      );

  GameState(
    this.players,
    this.bombs,
    this.hits,
    this.bullets,
  );

  factory GameState.fromBytes(Uint8List bytes) {
    var neededBytes = bytes.sublist(0, Player.allBytesCount);
    final players = PlayerViewModel.manyFromBytes(neededBytes);

    var leftBytes = bytes.sublist(neededBytes.length);
    neededBytes = leftBytes.sublist(0, Bullet.bytesCount);
    final bullets = BulletViewModel.manyFromBytes(neededBytes);

    leftBytes = leftBytes.sublist(neededBytes.length);
    neededBytes = leftBytes.sublist(0, Bomb.allBytesCount);
    final bombs = BombView.listFromBytes(neededBytes);

    leftBytes = leftBytes.sublist(neededBytes.length);
    neededBytes = leftBytes.sublist(0, maxPlayers);
    final hits = neededBytes;

    return GameState(players, bombs, hits, bullets);
  }

  static Uint8List bytes(
    List<Player> players,
    List<Bomb> bombs,
    List<int> hits,
    List<Bullet> bullets,
    List<int> frags,
  ) {
    final builder = BytesBuilder();
    builder.add(players.toBytes());
    builder.add(bullets.toBytes());
    builder.add(bombs.toBytes());
    builder.add(hits);

    return builder.toBytes();
  }
}
