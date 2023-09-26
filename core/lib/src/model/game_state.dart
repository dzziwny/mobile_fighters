import 'dart:typed_data';

import 'package:core/src/constants.dart';

import '../dto/hit.dto.dart';
import 'bomb.dart';
import 'bullet.dart';
import 'player.dart';

class GameState {
  final List<PlayerViewModel> players;
  final List<BombView> bombs;
  final List<HitDto> hits;
  final List<BulletViewModel> bullets;

  factory GameState.empty() => GameState(
        List.generate(maxPlayers, PlayerViewModel.empty),
        List.generate(maxBombs, BombView.empty),
        List.generate(maxPlayers, HitDto.empty),
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

    // var leftBytes = bytes.sublist(positionsBytesLength);
    // const bombsBytesLength = 4 * maxPlayers;
    // final bombsBytes = leftBytes.sublist(0, bombsBytesLength);
    // final bombs = BombView.listFromBytes(bombsBytes);

    // leftBytes = leftBytes.sublist(1 + bombsBytesLength);
    // final hitsLenght = leftBytes[0];
    // final hitsBytesLength = hitsLenght * 2;
    // final hitsBytes = leftBytes.sublist(1, 1 + hitsBytesLength);
    // final hits = HitDto.hitsFromBytes(hitsBytes);

    // leftBytes = leftBytes.sublist(1 + bulletsBytesLength);
    // final fragsLenght = leftBytes[0];
    // final fragsBytesLength = fragsLenght * 2;
    // final frags = leftBytes.sublist(1, 1 + fragsBytesLength);

    // return GameState(positions, bombs, hits, bullets, frags);
    return GameState(players, bombs, [], bullets);
  }

  static Uint8List bytes(
    List<Player> players,
    List<Bomb> bombs,
    List<HitDto> hits,
    List<Bullet> bullets,
    List<int> frags,
  ) {
    final builder = BytesBuilder();
    builder.add(players.toBytes());
    builder.add(bullets.toBytes());
    builder.add(bombs.toBytes());

    return builder.toBytes();
  }
}
