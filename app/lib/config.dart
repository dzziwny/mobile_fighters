import 'package:flutter/foundation.dart';

const kDebug = kDebugMode;
const showDebugLines = false;
const showDebugGameSettings = false;

final isMobile = defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS;
final showAttackButtons = isMobile;

const saveUuidInPrefs = !kDebug;
