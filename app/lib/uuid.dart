import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'config.dart';

late final String uuid;

String getUuid(SharedPreferences prefs) {
  if (!saveUuidInPrefs) {
    return const Uuid().v4();
  }

  final prefsUuid = prefs.getString('uuid');
  if (prefsUuid != null) {
    return prefsUuid;
  }

  final uuid = const Uuid().v4();
  prefs.setString('uuid', uuid);
  return uuid;
}
