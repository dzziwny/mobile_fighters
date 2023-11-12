import 'package:flutter/foundation.dart';

const kDebug = kDebugMode;

final isMobile = defaultTargetPlatform == TargetPlatform.android ||
    defaultTargetPlatform == TargetPlatform.iOS;
