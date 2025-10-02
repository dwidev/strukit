// ignore_for_file: invalid_annotation_target
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';

import '../local_storage_manager/local_storage_manager.dart';

@module
abstract class RegisterModule {
  @lazySingleton
  FirebaseAuth get firebaseAuth => FirebaseAuth.instance;

  @lazySingleton
  Dio get dio => Dio();

  @sharedPref
  @preResolve
  Future<LocalStorageAdapter> get sharedPreference =>
      LocalStorageFactory.get(type: StorageType.sharedPreference);
}
