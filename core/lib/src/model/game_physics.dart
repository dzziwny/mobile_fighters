import 'dart:convert';

import 'package:core/src/constants.dart' as constants;
import 'package:freezed_annotation/freezed_annotation.dart';

part 'game_physics.g.dart';

@JsonSerializable()
class GamePhysics {
  double n;
  double k;
  double f;
  double dashFrictionK;
  double dashforceRation;

  GamePhysics({
    this.n = constants.defaultPlayerFrictionN,
    this.k = constants.defaultPlayerFrictionK,
    this.f = constants.defaultPlayerForceRatio,
    this.dashFrictionK = constants.dashFrictionK,
    this.dashforceRation = constants.dashforceRation,
  });

  factory GamePhysics.fromJson(Map<String, dynamic> json) =>
      _$GamePhysicsFromJson(json);

  Map<String, dynamic> toJson() => _$GamePhysicsToJson(this);

  @override
  String toString() => jsonEncode(this);
}
