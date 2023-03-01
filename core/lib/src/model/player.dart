import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import 'device.dart';
import 'position.dart';
import 'team.dart';

part 'player.freezed.dart';
part 'player.g.dart';

@freezed
class Player with _$Player {
  const factory Player({
    required int id,
    required String nick,
    required Team team,
    required Device device,
    required Position position,
  }) = _Player;

  factory Player.fromJson(Map<String, dynamic> json) => _$PlayerFromJson(json);

  static Map<int, Player> parseToMap(String data) {
    final json = jsonDecode(data);
    final players = (json as List).map((e) => Player.fromJson(e));
    final map = <int, Player>{};
    for (var player in players) {
      map[player.id] = player;
    }

    return map;
  }
}
