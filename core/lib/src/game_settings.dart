import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vector_math/vector_math.dart';

part 'game_settings.g.dart';

@JsonSerializable()
class GameSettings {
  // Frames
  /// Set the desired frame rate (e.g., 60 frames per second)
  final int frameRate;

  /// If there are lags, try make sliceTime smaller
  final int sliceTimeMicroseconds;
  final double sliceTimeSeconds;

  // Player
  final int maxPlayers;
  final double playerFrictionN;
  final double playerFrictionK;
  final double playerForceRatio;
  final double playerStartHp;
  final double playerRadius;

  // Dash
  final double dashFrictionK;
  final double dashForceRatio;
  final int dashCooldown;
  final int dashDuration;

  // Bullet
  final int maxBullePerPlayer;
  final int maxBullets;
  final double bulletRadius;
  final double bulletDiameter;
  final double bulletRadiusSquared;
  final double bulletDistance;
  final double bulletDistanceSquared;
  final double bulletPlayerCollisionDistanceSquare;
  final int bulletsCooldown;
  final int bulletPower;
  final double bulletVelocity;

  // Bomb
  final int maxBombsPerPlayer;
  final int maxBombs;
  final double bombVelocity;
  final double bombRadius;
  final double bombDiameter;
  final double bombRadiusSquared;
  final double bombDistance;
  final double bombDistanceSquared;
  final double bombPlayerCollisionDistanceSquare;
  final int bombCooldown;
  final int bombPower;

  // Board
  final int battleGroundWidth;
  final int battleGroundHeight;

  final int battleGroundStartXInt;
  final double battleGroundStartX;
  final double battleGroundEndX;
  final int battleGroundEndXInt;

  final int battleGroundStartYInt;
  final double battleGroundStartY;
  final double battleGroundEndY;
  final int battleGroundEndYInt;

  final double resetX;
  final double resetY;
  Vector2 resetPosition() => Vector2(resetX, resetY);

  final double battleGroundFrameHorizontalThickness;
  final double battleGroundFrameVerticalThickness;

  final double battleGroundScreenRatio;

  final double screenWidth;
  final double screenHeight;
  final int respawnWidth;

  GameSettings copyWith({
    int? frameRate,
    int? sliceTimeMicroseconds,
    double? playerFrictionK,
    double? playerFrictionN,
    double? playerForceRatio,
    double? playerStartHp,
    double? playerRadius,
    double? dashFrictionK,
    double? dashForceRatio,
    int? dashCooldown,
    int? dashDuration,
    double? bulletRadius,
    double? bulletDistance,
    int? bulletsCooldown,
    int? bulletPower,
    double? bulletVelocity,
    double? bombRadius,
    double? bombDistance,
    int? bombCooldown,
    int? bombPower,
    double? bombVelocity,
  }) =>
      GameSettings(
        playerFrictionK: playerFrictionK ?? this.playerFrictionK,
        playerFrictionN: playerFrictionN ?? this.playerFrictionN,
        playerForceRatio: playerForceRatio ?? this.playerForceRatio,
        frameRate: frameRate ?? this.frameRate,
        sliceTimeMicroseconds:
            sliceTimeMicroseconds ?? this.sliceTimeMicroseconds,
        playerStartHp: playerStartHp ?? this.playerStartHp,
        playerRadius: playerRadius ?? this.playerRadius,
        dashFrictionK: dashFrictionK ?? this.dashFrictionK,
        dashForceRatio: dashForceRatio ?? this.dashForceRatio,
        dashCooldown: dashCooldown ?? this.dashCooldown,
        dashDuration: dashDuration ?? this.dashDuration,
        bulletRadius: bulletRadius ?? this.bulletRadius,
        bulletDistance: bulletDistance ?? this.bulletDistance,
        bulletsCooldown: bulletsCooldown ?? this.bulletsCooldown,
        bulletPower: bulletPower ?? this.bulletPower,
        bulletVelocity: bulletVelocity ?? this.bulletVelocity,
        bombRadius: bombRadius ?? this.bombRadius,
        bombDistance: bombDistance ?? this.bombDistance,
        bombCooldown: bombCooldown ?? this.bombCooldown,
        bombPower: bombPower ?? this.bombPower,
        bombVelocity: bombVelocity ?? this.bombVelocity,
      );

  const GameSettings({
    this.frameRate = 1000 ~/ 60,
    this.sliceTimeMicroseconds = 4000,
    this.playerFrictionN = 0.23,
    this.playerFrictionK = 0.6,
    this.playerForceRatio = 10.0,
    this.dashFrictionK = 0.0,
    this.dashForceRatio = 10.0,
    this.bulletVelocity = 2000.0,
    this.dashCooldown = 2,
    this.dashDuration = 1,
    this.maxPlayers = 10,
    this.playerStartHp = 210.0,
    this.playerRadius = 40.0,
    this.battleGroundWidth = 0xfff,
    this.battleGroundHeight = 0x777,
    this.battleGroundStartXInt = 0,
    this.battleGroundStartYInt = 0,
    this.screenWidth = 1000.0,
    this.respawnWidth = 150,
    this.maxBullePerPlayer = 10,
    this.bulletRadius = 15.0,
    this.bulletDistance = 316.0,
    this.bulletsCooldown = 100,
    this.bulletPower = 10,
    this.maxBombsPerPlayer = 1,
    this.bombVelocity = 1000.0,
    this.bombRadius = 100.0,
    this.bombDistance = 500.0,
    this.bombCooldown = 2,
    this.bombPower = 70,
  })  : sliceTimeSeconds = sliceTimeMicroseconds / 1000000.0,
        battleGroundStartX = battleGroundStartXInt + 0.0,
        battleGroundEndX = battleGroundStartXInt + battleGroundWidth + 0.0,
        battleGroundEndXInt = battleGroundStartXInt + battleGroundWidth,
        battleGroundStartY = battleGroundStartYInt + 0.0,
        battleGroundEndY = battleGroundStartYInt + battleGroundHeight + 0.0,
        battleGroundEndYInt = battleGroundStartYInt + battleGroundHeight,
        resetX = battleGroundStartXInt + battleGroundWidth + 200.0,
        resetY = battleGroundStartYInt + battleGroundHeight + 200.0,
        battleGroundFrameHorizontalThickness = 40.0,
        battleGroundFrameVerticalThickness = 10.0,
        battleGroundScreenRatio = battleGroundHeight / battleGroundWidth,
        screenHeight = screenWidth * (battleGroundHeight / battleGroundWidth),
        maxBullets = maxPlayers * maxBullePerPlayer,
        bulletDiameter = 2 * bulletRadius,
        bulletRadiusSquared = bulletRadius * bulletRadius,
        bulletDistanceSquared = bulletDistance * bulletDistance,
        bulletPlayerCollisionDistanceSquare =
            (bulletRadius * bulletRadius) + (playerRadius * playerRadius),
        maxBombs = maxPlayers * maxBombsPerPlayer,
        bombDiameter = bombRadius * 2,
        bombRadiusSquared = bombRadius * bombRadius,
        bombDistanceSquared = bombDistance * bombDistance,
        bombPlayerCollisionDistanceSquare =
            (bombRadius * bombRadius) + (playerRadius * playerRadius);

  factory GameSettings.fromJson(Map<String, dynamic> json) =>
      _$GameSettingsFromJson(json);

  Map<String, dynamic> toJson() => _$GameSettingsToJson(this);

  @override
  String toString() => jsonEncode(this);
}

var gameSettings = GameSettings();
