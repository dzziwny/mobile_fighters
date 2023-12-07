import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:vector_math/vector_math.dart';

part 'game_settings.g.dart';

@JsonSerializable()
class GameSettings {
  /// Set the desired frame rate (e.g., 60 frames per second)
  final int frameRate;

  /// If there are lags, try make sliceTime smaller
  final int sliceTimeMicroseconds;
  final double sliceTimeSeconds;

  final double frictionN;
  final double frictionK;
  final double forceRatio;
  final double dashFrictionK;
  final double dashforceRation;
  final double bulletVelocity;
  final int dashCooldown;
  final int dashDuration;

  // PLAYERS FEATURES
  final int maxPlayers;
  final double startHp;

  final double playerRadius;
  final double playerRadiusSquare;
  final double playerDiameter;
  final double playerPhoneHeight;
  final double playerPhoneWidth;

  // BOARD
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

  // Ultra HD xddd
  final double screenWidth;
  final double screenHeight;

  // RESPAWNS
  final int respawnWidth;

  // BULLET
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

  // BOMB
  final int maxBombsPerPlayer;
  final int maxBombs;
  final double initBombVelocity;
  final double bombRadius;
  final double bombDiameter;
  final double bombRadiusSquared;
  final double bombDistance;
  final double bombDistanceSquared;
  final double bombPlayerCollisionDistanceSquare;
  final int bombCooldown;
  final int bombPower;

  GameSettings copyWith({
    double? frictionK,
    double? frictionN,
    double? forceRatio,
    int? frameRate,
  }) =>
      GameSettings(
        frictionK: frictionK ?? this.frictionK,
        frictionN: frictionN ?? this.frictionN,
        forceRatio: forceRatio ?? this.forceRatio,
        frameRate: frameRate ?? this.frameRate,
      );

  const GameSettings({
    this.frameRate = 1000 ~/ 60,
    this.sliceTimeMicroseconds = 5000,
    this.frictionN = 0.23,
    this.frictionK = 0.6,
    this.forceRatio = 12.0,
    this.dashFrictionK = 0.0,
    this.dashforceRation = 10.0,
    this.bulletVelocity = 2000.0,
    this.dashCooldown = 2,
    this.dashDuration = 1,
    this.maxPlayers = 10,
    this.startHp = 210.0,
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
    this.initBombVelocity = 1000.0,
    this.bombRadius = 100.0,
    this.bombDistance = 500.0,
    this.bombCooldown = 2,
    this.bombPower = 70,
  })  : sliceTimeSeconds = sliceTimeMicroseconds / 1000000.0,
        playerRadiusSquare = playerRadius * playerRadius,
        playerDiameter = playerRadius * 2,
        playerPhoneHeight = (playerRadius * 2) + 64.0,
        playerPhoneWidth = (playerRadius * 2) + 9.0,
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
