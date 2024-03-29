import 'package:flutter/foundation.dart';

const kDebug = kDebugMode;
const showDebugLines = false;
const showDebugGameSettings = true;

final isMobile = defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS;

final showButtonsRail = isMobile;
final showLeaveButton = !isMobile;

const saveUuidInPrefs = !kDebug;

const displaySplash = !kDebug;
const forceSomeTimeOnSplash = !kDebug;
