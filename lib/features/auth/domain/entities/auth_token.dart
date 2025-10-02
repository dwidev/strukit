import 'package:equatable/equatable.dart';

class AuthToken extends Equatable {
  final bool isRegistered;
  final String accessToken;
  final String refreshToken;

  const AuthToken({
    required this.isRegistered,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  List<Object> get props => [isRegistered, accessToken, refreshToken];

  @override
  bool get stringify => true;
}
