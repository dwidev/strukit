import 'dart:convert';

import '../../domain/entities/auth_token.dart';

class TokenModel {
  final bool isRegistered;
  final String accessToken;
  final String refreshToken;

  TokenModel({
    this.isRegistered = false,
    required this.accessToken,
    required this.refreshToken,
  });

  AuthToken toAuth() => AuthToken(
    isRegistered: isRegistered,
    accessToken: accessToken,
    refreshToken: refreshToken,
  );

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }

  factory TokenModel.fromMap(Map<String, dynamic> map) {
    return TokenModel(
      accessToken: map['accessToken'] as String,
      refreshToken: map['refreshToken'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TokenModel.fromJson(String source) =>
      TokenModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TokenModel(accessToken: $accessToken, refreshToken: $refreshToken)';
}
