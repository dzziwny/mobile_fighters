import 'package:core/core.dart';

const hpBarHeight = 16.0;
const playerNickHeight = 20.0;
const hpBarNickSpace = 8.0;
const nickCharacterSpace = 8.0;

const withoutPlayerAreaHeight =
    hpBarHeight + playerNickHeight + hpBarNickSpace + nickCharacterSpace;
const fullPlayerAreaHeight = withoutPlayerAreaHeight + playerPhoneHeight;

const fullPlayerAreaWidth = 100.0;

const playerHeightOffest = withoutPlayerAreaHeight + (playerPhoneHeight / 2.0);
const playerWidthOffest = fullPlayerAreaWidth / 2.0;
