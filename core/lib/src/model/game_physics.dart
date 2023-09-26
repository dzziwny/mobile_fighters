import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_physics.g.dart';

@JsonSerializable()
class GamePhysics {
  double n;
  double k;
  double f;

  GamePhysics({
    this.n = 0.25,
    this.k = 0.1,
    this.f = 10.0,
  });

  factory GamePhysics.fromJson(Map<String, dynamic> json) =>
      _$GamePhysicsFromJson(json);

  Map<String, dynamic> toJson() => _$GamePhysicsToJson(this);

  @override
  String toString() => jsonEncode(this);
}
