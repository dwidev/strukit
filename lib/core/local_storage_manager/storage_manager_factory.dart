import 'package:shared_preferences/shared_preferences.dart';

import 'local_storage_manager.dart';

enum StorageType { sharedPreference }

class LocalStorageFactory {
  static Future<LocalStorageAdapter> get({required StorageType type}) async {
    switch (type) {
      case StorageType.sharedPreference:
        final pref = await SharedPreferences.getInstance();
        return SharedPreferenceManager(sharedPreferences: pref);
    }
  }
}
