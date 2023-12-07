import 'package:core/core.dart';

class GameUISettings {
  GameUISettings({
    GameSettings settings = const GameSettings(),
    this.hpBarHeight = 16.0,
    this.playerNickHeight = 20.0,
    this.hpBarNickSpace = 8.0,
    this.nickCharacterSpace = 8.0,
    this.fullPlayerAreaWidth = 100.0,
    this.goldenRatio = 1.61803398875,
  })  : withoutPlayerAreaHeight = hpBarHeight +
            playerNickHeight +
            hpBarNickSpace +
            nickCharacterSpace,
        playerPhoneHeight = (settings.playerRadius * 2) + 64.0,
        playerPhoneWidth = (settings.playerRadius * 2) + 9.0,
        fullPlayerAreaHeight = hpBarHeight +
            playerNickHeight +
            hpBarNickSpace +
            nickCharacterSpace +
            (settings.playerRadius * 2) +
            64.0,
        playerHeightOffest = hpBarHeight +
            playerNickHeight +
            hpBarNickSpace +
            nickCharacterSpace +
            (((settings.playerRadius * 2) + 64.0) / 2.0),
        playerWidthOffest = fullPlayerAreaWidth / 2.0;

  final double hpBarHeight;
  final double playerNickHeight;
  final double hpBarNickSpace;
  final double nickCharacterSpace;
  final double withoutPlayerAreaHeight;
  final double playerPhoneHeight;
  final double playerPhoneWidth;
  final double fullPlayerAreaHeight;
  final double fullPlayerAreaWidth;

  final double playerHeightOffest;
  final double playerWidthOffest;

  final double goldenRatio;
}

var gameUISettings = GameUISettings();
