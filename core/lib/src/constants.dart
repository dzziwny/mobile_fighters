// GAME RULES
import 'package:core/src/model/_model.dart';

const maxPlayers = 10;

// If there are lags, try make sliceTime smaller
const int sliceTimeMicroseconds = 5000;
const double sliceTimeMicrosecondsDouble = sliceTimeMicroseconds + 0.0;
const double sliceTimeSeconds = sliceTimeMicroseconds / 1000000.0;

const int dashCooldownSeconds = 1;
const int pushCooldownMilisesconds = 20;

// PLAYERS FEATURES
const int startHp = 210;
const double startHpDouble = 210.0;

const double normalSpeed = 0.00001;
const double dashSpeed = 0.00005;

const playerRadius = 40.0;
const playerDiameter = playerRadius * 2;
const playerPhoneHeight = playerDiameter + 64.0;
const playerPhoneWidth = playerDiameter + 9.0;

// BOARD
const int boardWidth = 0xfff;
const int boardHeight = 0x777;

const double boardWidthDouble = boardWidth + 0.0;
const double boardHeightDouble = boardHeight + 0.0;

const double boardStartX = 0.0;
const double boardEndX = boardStartX + boardWidthDouble;

const double boardStartY = 0.0;
const double boardEndY = boardStartY + boardHeightDouble;

const double borderHorizontalPadding = 40.0;
const double borderVerticalPadding = 10.0;

const boardScreenRatio = boardHeight / boardWidth;

// Ultra HD xddd
const borderWidth = 1000.0;
const borderHeight = borderWidth * boardScreenRatio;

// RESPAWNS
const int respawnWidth = 150;

const goldenRatio = 1.61803398875;

// PHYSICS
final gamePhysics = GamePhysics();

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
const double bombDistanceSquare = bombDistance * bombDistance;
const bombCooldown = Duration(seconds: 2);
const int bombPower = 70;
