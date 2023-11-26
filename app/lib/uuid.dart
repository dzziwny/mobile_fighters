import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import 'config.dart';

late final String uuid;

Future<String> getUuid() async {
  if (!saveUuidInPrefs) {
    return const Uuid().v4();
  }

  final prefs = await SharedPreferences.getInstance();
  final prefsUuid = prefs.getString('uuid');
  if (prefsUuid != null) {
    return prefsUuid;
  }

  final uuid = const Uuid().v4();
  await prefs.setString('uuid', uuid);
  return uuid;
}
