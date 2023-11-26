import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'config.dart';
import 'shared_preferences.dart';

final String uuid = _getUuid(prefs);

String _getUuid(SharedPreferences prefs) {
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
