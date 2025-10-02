import 'dart:convert';

class UserLoginResponse {
  final String userId;
  final String username;
  final String email;

  UserLoginResponse(
      {required this.userId, required this.username, required this.email});

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'userId': userId,
      'username': username,
      'email': email,
    };
  }

  factory UserLoginResponse.fromMap(Map<String, dynamic> map) {
    return UserLoginResponse(
      userId: map['userId'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory UserLoginResponse.fromJson(String source) =>
      UserLoginResponse.fromMap(json.decode(source) as Map<String, dynamic>);
}
