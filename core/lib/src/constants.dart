// GAME RULES
import 'package:core/src/model/_model.dart';

const maxPlayers = 10;

const maxBullePerPlayer = 10;
const maxBullets = maxPlayers * maxBullePerPlayer;

const maxBombsPerPlayer = 1;
const maxBombs = maxPlayers * maxBombsPerPlayer;

// DURATIONS
const attackUntilBoomDuration = Duration(milliseconds: 1000);
const attackFlyingAnimationDuration = Duration(milliseconds: 1000);

// If there are lags, try make sliceTime smaller
const int sliceTimeMicroseconds = 5000;
const double sliceTimeMicrosecondsDouble = sliceTimeMicroseconds + 0.0;
const double sliceTimeSeconds = sliceTimeMicroseconds / 1000000.0;

const int bombCooldownSesconds = 2;
const int dashCooldownSesconds = 1;
const int pushCooldownMilisesconds = 20;
const int bulletsCooldownMilisesconds = 100;

// DIMENSIONS
const double attackLength = 200.0;
const double attackAreaRadius = 100.0;
const double attackAreaDiameter = attackAreaRadius * 2;
const double attackAreaRadiusSquared = attackAreaRadius * attackAreaRadius;
const double bombRange = 1000;

// PLAYERS FEATURES
const int bombPower = 70;
const int bulletPower = 10;
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

const borderHorizontalPadding = 40.0;
const borderVerticalPadding = 10.0;
// Ultra HD xddd
const boardScreenRatio = boardHeight / boardWidth;
const borderWidth = 1000.0;
const borderHeight = borderWidth * boardScreenRatio;

// RESPAWNS
const int respawnWidth = 150;

const goldenRatio = 1.61803398875;

// PHYSICS
final gamePhysics = GamePhysics();

// ATTACKS
const initBulletScale = 2000.0;
const initBombScale = 200.0;
