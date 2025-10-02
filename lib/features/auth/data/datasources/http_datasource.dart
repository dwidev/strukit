import 'package:dio/dio.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:injectable/injectable.dart';

import '../model/token_model.dart';

abstract class AuthHTTPDataSource {
  Future<TokenModel> verifyOTP({required String otp});
  Future<TokenModel> signWithEmail({required String email});
  Future<TokenModel> signWithPhoneNumber({required String phoneNumber});
}

@LazySingleton(as: AuthHTTPDataSource)
class AuthHTTPDataSourceImpl implements AuthHTTPDataSource {
  final Dio dio;

  AuthHTTPDataSourceImpl({required this.dio});

  @override
  Future<TokenModel> signWithEmail({required String email}) async {
    await Future.delayed(500.ms);

    final result = TokenModel(
      isRegistered: false,
      accessToken: "accessToken",
      refreshToken: "refreshToken",
    );
    return result;
  }

  @override
  Future<TokenModel> signWithPhoneNumber({required String phoneNumber}) async {
    await Future.delayed(500.ms);

    final result = TokenModel(
      isRegistered: false,
      accessToken: "accessToken",
      refreshToken: "refreshToken",
    );
    return result;
  }

  @override
  Future<TokenModel> verifyOTP({required String otp}) async {
    await Future.delayed(1.seconds);

    final result = TokenModel(
      isRegistered: false,
      accessToken: "accessToken",
      refreshToken: "refreshToken",
    );
    return result;
  }
}
