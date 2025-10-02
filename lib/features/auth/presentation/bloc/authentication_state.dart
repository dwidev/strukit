// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'authentication_bloc.dart';

@immutable
class AuthenticationState extends Equatable {
  final bool isLoading;
  final UserData? userData;

  const AuthenticationState({
    this.isLoading = false,
    this.userData,
  });

  @override
  List<Object?> get props => [isLoading, userData];

  AuthenticationState copyWith({
    bool? isLoading,
    UserData? userData,
  }) {
    return AuthenticationState(
      isLoading: isLoading ?? this.isLoading,
      userData: userData ?? this.userData,
    );
  }

  @override
  bool get stringify => true;
}

final class AuthenticationInitial extends AuthenticationState {}

final class AuthenticationSignSuccess extends AuthenticationState {
  const AuthenticationSignSuccess({required super.userData});

  @override
  List<Object?> get props => [super.userData];
}

final class AuthenticationSignSuccessNotRegistered extends AuthenticationState {
  const AuthenticationSignSuccessNotRegistered({required super.userData});

  @override
  List<Object?> get props => [super.userData];
}

final class AuthenticationSignError extends AuthenticationState {
  final Exception error;

  const AuthenticationSignError({required this.error});

  @override
  List<Object> get props => [error];
}
