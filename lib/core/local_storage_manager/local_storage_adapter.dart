import 'package:injectable/injectable.dart';

const sharedPref = Named('shared_preference');
const mockStorage = Named('mock_storage');

abstract class LocalStorageAdapter {
  Future<Object?> getData(String key);
  Future<void> storeData(String key, Object value);
  Future<void> clear();
  Future<void> remove(String key);
}
