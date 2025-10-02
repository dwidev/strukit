import 'package:strukit/features/auth/domain/entities/sign_type.dart';

import '../entities/authorize.dart';
import '../entities/user_data.dart';

abstract class AuthenticationRepository {
  Future<AuthorizeResult> authorizedChecking();
  Future<UserData> signWithGoogle();
  Future<UserData> signWithApple();
  Future<UserData> signWithPhoneOrEmail({
    required String data,
    required SignType signType,
  });
  Future<UserData> verifyOTP({required String otp});
  Future<void> clearAuthStorage();
}
