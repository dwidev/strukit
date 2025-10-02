import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import 'local_storage_adapter.dart';

class MockStorageManager implements LocalStorageAdapter {
  @override
  Future<Object?> getData(String key) {
    return Future.value("Mock get data");
  }

  @override
  Future<void> storeData(String key, Object value) async {
    await Future.delayed(100.ms);
    debugPrint("this mock store $value");
  }

  @override
  Future<void> clear() async {
    debugPrint("clear mock");
  }

  @override
  Future<void> remove(String key) async {
    debugPrint("remove by key $key");
  }
}
