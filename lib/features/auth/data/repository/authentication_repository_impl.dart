import 'package:injectable/injectable.dart';

import '../../domain/entities/authorize.dart';
import '../../domain/entities/sign_type.dart';
import '../../domain/entities/user_data.dart';
import '../../domain/repository/authentication_repository.dart';
import '../datasources/auth_localstorage_datasource.dart';
import '../datasources/firebase_datasource.dart';
import '../datasources/http_datasource.dart';
import '../model/token_model.dart';

@LazySingleton(as: AuthenticationRepository)
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final AuthFirebaseDataSource authFirebaseDataSource;
  final AuthHTTPDataSource authHTTPDataSource;
  final AuthLocalStorageDataSource authLocalStorageDataSource;

  AuthenticationRepositoryImpl({
    required this.authFirebaseDataSource,
    required this.authHTTPDataSource,
    required this.authLocalStorageDataSource,
  });

  @override
  Future<UserData> signWithApple() {
    throw UnimplementedError();
  }

  @override
  Future<UserData> signWithGoogle() async {
    final credential = await authFirebaseDataSource.signWithGoogle();

    final email = credential.user?.email ?? "";
    final sign = await authHTTPDataSource.signWithEmail(email: email);

    await Future.wait([
      authLocalStorageDataSource.setToken(sign),
      authLocalStorageDataSource.setCompleteRegisStatus(sign.isRegistered),
    ]);

    return UserData(
      userId: credential.user?.uid ?? "",
      username: credential.user?.displayName ?? "",
      email: credential.user?.email ?? "",
      authToken: sign.toAuth(),
    );
  }

  @override
  Future<UserData> signWithPhoneOrEmail({
    required String data,
    required SignType signType,
  }) async {
    late TokenModel tokenModel;
    if (signType == SignType.email) {
      final response = await authHTTPDataSource.signWithEmail(email: data);
      tokenModel = response;
    } else {
      final response = await authHTTPDataSource.signWithPhoneNumber(
        phoneNumber: data,
      );
      tokenModel = response;
    }

    return UserData(
      userId: "userId",
      username: "username",
      email: "email",
      authToken: tokenModel.toAuth(),
    );
  }

  @override
  Future<AuthorizeResult> authorizedChecking() async {
    final check = await Future.wait([
      authLocalStorageDataSource.getToken(),
      authLocalStorageDataSource.completeRegis(),
    ]);

    final token = check[0] as TokenModel;
    final registered = check[1] as bool;

    if (token.accessToken.isEmpty || token.refreshToken.isEmpty) {
      await authLocalStorageDataSource.clear();
      return AuthorizeResult.logout;
    }

    if (registered) {
      return AuthorizeResult.signInWithComplete;
    } else {
      return AuthorizeResult.signInNotComplete;
    }
  }

  @override
  Future<void> clearAuthStorage() async {
    await authLocalStorageDataSource.clear();
  }

  @override
  Future<UserData> verifyOTP({required String otp}) async {
    final response = await authHTTPDataSource.verifyOTP(otp: otp);
    return UserData(
      userId: "userId",
      username: "username",
      email: "email",
      authToken: response.toAuth(),
    );
  }
}
