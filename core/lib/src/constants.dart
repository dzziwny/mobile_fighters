// DURATIONS
const attackUntilBoomDuration = Duration(milliseconds: 1000);
const attackFlyingAnimationDuration = Duration(milliseconds: 1000);

// If there are lags, try make sliceTime smaller
const int sliceTimeMicroseconds = 5000;
const double sliceTimeSeconds = sliceTimeMicroseconds / 1000000.0;

const int attackCooldownSesconds = 2;
const int dashCooldownSesconds = 1;
const int pushCooldownMilisesconds = 20;

// DIMENSIONS
const double attackLength = 200.0;
const double attackAreaRadius = 100.0;
const double attackAreaDiameter = attackAreaRadius * 2;
const double attackAreaRadiusSquared = attackAreaRadius * attackAreaRadius;

// PLAYERS FEATURES
const int attackPower = 70;
const int startHp = 210;
double startHpDouble = startHp.toDouble();

const double normalSpeed = 0.00001;
const double dashSpeed = 0.00005;

const playerRadius = 40.0;
const playerDiameter = playerRadius * 2;
const playerPhoneHeight = playerDiameter + 64.0;
const playerPhoneWidth = playerDiameter + 9.0;

//FRAME
// Ultra HD xddddd
const int boardWidth = 255 * 8;
const int boardHeight = 255 * 6;

const double boardWidthDouble = boardWidth + 0.0;
const double boardHeightDouble = boardHeight + 0.0;

// RESPAWNS
const double respawnWidth = 150.0;

const goldenRatio = 1.61803398875;
