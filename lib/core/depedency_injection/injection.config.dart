// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:dio/dio.dart' as _i361;
import 'package:firebase_auth/firebase_auth.dart' as _i59;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:strukit/core/depedency_injection/register_module.dart' as _i686;
import 'package:strukit/core/local_storage_manager/local_storage_adapter.dart'
    as _i231;
import 'package:strukit/core/local_storage_manager/local_storage_manager.dart'
    as _i331;
import 'package:strukit/features/auth/data/datasources/auth_localstorage_datasource.dart'
    as _i480;
import 'package:strukit/features/auth/data/datasources/firebase_datasource.dart'
    as _i390;
import 'package:strukit/features/auth/data/datasources/http_datasource.dart'
    as _i837;
import 'package:strukit/features/auth/data/repository/authentication_repository_impl.dart'
    as _i815;
import 'package:strukit/features/auth/domain/repository/authentication_repository.dart'
    as _i200;
import 'package:strukit/features/auth/domain/usecase/authorized_checking.dart'
    as _i420;
import 'package:strukit/features/auth/domain/usecase/clear_auth_storage.dart'
    as _i897;
import 'package:strukit/features/auth/domain/usecase/sign_with_email.dart'
    as _i16;
import 'package:strukit/features/auth/domain/usecase/sign_with_google.dart'
    as _i235;
import 'package:strukit/features/auth/domain/usecase/sign_with_phonenumber.dart'
    as _i68;
import 'package:strukit/features/auth/domain/usecase/verify_otp.dart' as _i285;
import 'package:strukit/features/auth/presentation/bloc/authentication_bloc.dart'
    as _i915;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    gh.lazySingleton<_i59.FirebaseAuth>(() => registerModule.firebaseAuth);
    gh.lazySingleton<_i361.Dio>(() => registerModule.dio);
    await gh.factoryAsync<_i331.LocalStorageAdapter>(
      () => registerModule.sharedPreference,
      instanceName: 'shared_preference',
      preResolve: true,
    );
    gh.lazySingleton<_i837.AuthHTTPDataSource>(
      () => _i837.AuthHTTPDataSourceImpl(dio: gh<_i361.Dio>()),
    );
    gh.lazySingleton<_i390.AuthFirebaseDataSource>(
      () => _i390.AuthFirebaseDataSourceImpl(
        firebaseAuth: gh<_i59.FirebaseAuth>(),
      ),
    );
    gh.lazySingleton<_i480.AuthLocalStorageDataSource>(
      () => _i480.AuthLocalStorageDataSourceImpl(
        adapter: gh<_i231.LocalStorageAdapter>(
          instanceName: 'shared_preference',
        ),
      ),
    );
    gh.lazySingleton<_i200.AuthenticationRepository>(
      () => _i815.AuthenticationRepositoryImpl(
        authFirebaseDataSource: gh<_i390.AuthFirebaseDataSource>(),
        authHTTPDataSource: gh<_i837.AuthHTTPDataSource>(),
        authLocalStorageDataSource: gh<_i480.AuthLocalStorageDataSource>(),
      ),
    );
    gh.lazySingleton<_i897.ClearAuthStorage>(
      () => _i897.ClearAuthStorage(
        authenticationRepository: gh<_i200.AuthenticationRepository>(),
      ),
    );
    gh.lazySingleton<_i420.AuthorizedChecking>(
      () => _i420.AuthorizedChecking(
        authenticationRepository: gh<_i200.AuthenticationRepository>(),
      ),
    );
    gh.lazySingleton<_i16.SignWithEmail>(
      () => _i16.SignWithEmail(
        authenticationRepository: gh<_i200.AuthenticationRepository>(),
      ),
    );
    gh.lazySingleton<_i285.VerifyOTP>(
      () => _i285.VerifyOTP(
        authenticationRepository: gh<_i200.AuthenticationRepository>(),
      ),
    );
    gh.lazySingleton<_i68.SignWithPhoneNumber>(
      () => _i68.SignWithPhoneNumber(
        authenticationRepository: gh<_i200.AuthenticationRepository>(),
      ),
    );
    gh.lazySingleton<_i235.SignWithGoogle>(
      () => _i235.SignWithGoogle(
        authenticationRepository: gh<_i200.AuthenticationRepository>(),
      ),
    );
    gh.factory<_i915.AuthenticationBloc>(
      () => _i915.AuthenticationBloc(
        signWithGoogle: gh<_i235.SignWithGoogle>(),
        authorizedChecking: gh<_i420.AuthorizedChecking>(),
        signWithPhoneNumber: gh<_i68.SignWithPhoneNumber>(),
        signWithEmail: gh<_i16.SignWithEmail>(),
      ),
    );
    gh.factory<_i915.AuthenticationOTPBloc>(
      () => _i915.AuthenticationOTPBloc(
        verifyOTP: gh<_i285.VerifyOTP>(),
        signWithGoogle: gh<_i235.SignWithGoogle>(),
        authorizedChecking: gh<_i420.AuthorizedChecking>(),
        signWithPhoneNumber: gh<_i68.SignWithPhoneNumber>(),
        signWithEmail: gh<_i16.SignWithEmail>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i686.RegisterModule {}
