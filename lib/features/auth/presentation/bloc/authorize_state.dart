part of 'authentication_bloc.dart';

abstract class AuthorizeState extends AuthenticationState {
  const AuthorizeState();
}

final class AuthorizeSignComplete extends AuthorizeState {
  const AuthorizeSignComplete();
}

final class AuthorizeSignNotComplete extends AuthorizeState {
  const AuthorizeSignNotComplete();
}

final class AuthorizeSignNotValidOrLogout extends AuthorizeState {
  const AuthorizeSignNotValidOrLogout();
}
