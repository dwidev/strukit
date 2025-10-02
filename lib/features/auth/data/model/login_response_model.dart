import 'dart:convert';

import 'user_login_model.dart';

class LoginResponse {
  String status;
  String message;
  UserLoginResponse user;
  String token;

  LoginResponse({
    required this.status,
    required this.message,
    required this.user,
    required this.token,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'status': status,
      'message': message,
      'user': user.toMap(),
      'token': token,
    };
  }

  factory LoginResponse.fromMap(Map<String, dynamic> map) {
    return LoginResponse(
      status: map['status'] as String,
      message: map['message'] as String,
      user: UserLoginResponse.fromMap(map['user'] as Map<String, dynamic>),
      token: map['token'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory LoginResponse.fromJson(String source) =>
      LoginResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
