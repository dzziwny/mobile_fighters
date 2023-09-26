import 'dart:convert';

import 'package:core/src/model/_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'game_data.g.dart';

@JsonSerializable(explicitToJson: true)
class GameData {
  List<Player> players;

  GameData({
    List<Player>? players,
  }) : players = players ?? List.generate(10, Player.empty);

  factory GameData.fromJson(Map<String, dynamic> json) =>
      _$GameDataFromJson(json);

  Map<String, dynamic> toJson() => _$GameDataToJson(this);

  @override
  String toString() => jsonEncode(this);

  factory GameData.fromString(String data) =>
      GameData.fromJson(jsonDecode(data));
}
