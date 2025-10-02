part of 'authentication_bloc.dart';

sealed class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

final class AuthorizedCheckingEvent extends AuthenticationEvent {
  const AuthorizedCheckingEvent();
}

final class SignWithGoogleEvent extends AuthenticationEvent {
  const SignWithGoogleEvent();
}

final class SignWithPhoneNumberEvent extends AuthenticationEvent {
  final String phoneNumber;

  const SignWithPhoneNumberEvent({required this.phoneNumber});
}

final class SignWithEmailEvent extends AuthenticationEvent {
  final String email;

  const SignWithEmailEvent({required this.email});
}

final class VerifyOTPEvent extends AuthenticationEvent {
  final String otp;

  const VerifyOTPEvent({required this.otp});
}
