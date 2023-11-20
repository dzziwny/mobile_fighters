// GAME RULES
import 'package:core/src/model/_model.dart';
import 'package:vector_math/vector_math.dart';

const maxPlayers = 10;

/// Set the desired frame rate (e.g., 60 frames per second)
const frameRate = Duration(milliseconds: 1000 ~/ 60);

/// If there are lags, try make sliceTime smaller
const int sliceTimeMicroseconds = 5000;
const double sliceTimeSeconds = sliceTimeMicroseconds / 1000000.0;

// PLAYERS FEATURES
const double startHp = 210.0;

const playerRadius = 40.0;
const playerRadiusSquare = playerRadius * playerRadius;
const playerDiameter = playerRadius * 2;
const playerPhoneHeight = playerDiameter + 64.0;
const playerPhoneWidth = playerDiameter + 9.0;

// BOARD
const int battleGroundWidth = 0xfff;
const int battleGroundHeight = 0x777;

const int battleGroundStartXInt = 0;
const double battleGroundStartX = battleGroundStartXInt + 0.0;
const double battleGroundEndX = battleGroundStartX + battleGroundWidth;
const int battleGroundEndXInt = battleGroundStartXInt + battleGroundWidth;

const int battleGroundStartYInt = 0;
const double battleGroundStartY = battleGroundStartYInt + 0.0;
const double battleGroundEndY = battleGroundStartY + battleGroundHeight;
const int battleGroundEndYInt = battleGroundStartYInt + battleGroundHeight;

const double resetX = battleGroundEndX + 200;
const double resetY = battleGroundEndY + 200;
get resetPosition => Vector2(resetX, resetY);

const double battleGroundFrameHorizontalThickness = 40.0;
const double battleGroundFrameVerticalThickness = 10.0;

const battleGroundScreenRatio = battleGroundHeight / battleGroundWidth;

// Ultra HD xddd
const screenWidth = 1000.0;
const screenHeight = screenWidth * battleGroundScreenRatio;

// RESPAWNS
const int respawnWidth = 150;

const goldenRatio = 1.61803398875;

// PHYSICS
final gamePhysics = GamePhysics();
const defaultPlayerFrictionK = 0.1;
const defaultPlayerFrictionN = 0.25;
const defaultPlayerForceRatio = 5.0;

// ATTACKS

// BULLET
const maxBullePerPlayer = 10;
const maxBullets = maxPlayers * maxBullePerPlayer;
const initBulletVelocity = 2000.0;
const double bulletRadius = 15.0;
const double bulletDiameter = 2 * bulletRadius;
const double bulletRadiusSquared = bulletRadius * bulletRadius;
const double bulletDistance = 316.0;
const double bulletDistanceSquared = bulletDistance * bulletDistance;
const double bulletPlayerCollisionDistanceSquare =
    bulletRadiusSquared + playerRadiusSquare;
const bulletsCooldown = Duration(milliseconds: 100);
const int bulletPower = 10;

// BOMB
const maxBombsPerPlayer = 1;
const maxBombs = maxPlayers * maxBombsPerPlayer;
const initBombVelocity = 1000.0;
const double bombRadius = 100.0;
const double bombDiameter = bombRadius * 2;
const double bombRadiusSquared = bombRadius * bombRadius;
const double bombDistance = 500.0;
const double bombDistanceSquared = bombDistance * bombDistance;
const double bombPlayerCollisionDistanceSquare =
    bombRadiusSquared + playerRadiusSquare;
const bombCooldown = Duration(seconds: 2);
const int bombPower = 70;

// DASH
const dashFrictionK = 0.0;
const dashforceRation = 10.0;
const dashCooldown = Duration(seconds: 2);
const dashDuration = Duration(seconds: 1);
