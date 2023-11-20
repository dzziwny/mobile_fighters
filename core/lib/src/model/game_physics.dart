import 'dart:convert';

import 'package:core/src/constants.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_physics.g.dart';

@JsonSerializable()
class GamePhysics {
  double n;
  double k;
  double f;

  GamePhysics({
    this.n = defaultPlayerFrictionN,
    this.k = defaultPlayerFrictionK,
    this.f = defaultPlayerForceRatio,
  });

  factory GamePhysics.fromJson(Map<String, dynamic> json) =>
      _$GamePhysicsFromJson(json);

  Map<String, dynamic> toJson() => _$GamePhysicsToJson(this);

  @override
  String toString() => jsonEncode(this);
}
