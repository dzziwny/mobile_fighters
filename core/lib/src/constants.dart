const attackUntilBoomDuration = Duration(milliseconds: 1000);
const attackFlyingAnimationDuration = Duration(milliseconds: 1000);

const int attackCooldownSesconds = 2;
const int dashCooldownSesconds = 1;

const double attackLength = 200.0;
const double attackAreaRadius = 100.0;
const double attackAreaDiameter = attackAreaRadius * 2;
const double attackAreaRadiusSquared = attackAreaRadius * attackAreaRadius;

const int attackPower = 70;
const int startHp = 210;
double startHpDouble = startHp.toDouble();

// If there are lags, try make sliceTime smaller
const int sliceTimeMicroseconds = 5000;
const double sliceTimeSeconds = sliceTimeMicroseconds / 1000000.0;

const double normalSpeed = 0.00001;
const double dashSpeed = 0.00005;

// Ultra HD xddddd
const double frameWidth = 2160.0;
const double frameHeight = 1620.0;
const int pushCooldownMilisesconds = 20;
