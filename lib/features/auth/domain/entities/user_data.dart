import 'package:equatable/equatable.dart';

import 'auth_token.dart';

class UserData extends Equatable {
  final String userId;
  final String username;
  final String email;
  final AuthToken authToken;

  const UserData({
    required this.userId,
    required this.username,
    required this.email,
    required this.authToken,
  });

  @override
  List<Object?> get props => [userId, username, email, authToken];

  @override
  bool get stringify => true;
}
