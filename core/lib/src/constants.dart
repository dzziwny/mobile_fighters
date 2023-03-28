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

//FRAME
// Ultra HD xddddd
const double boardWidth = 2160.0;
const double boardHeight = 1620.0;

// RESPAWNS
const double respawnWidth = 150.0;

const goldenRatio = 1.61803398875;
