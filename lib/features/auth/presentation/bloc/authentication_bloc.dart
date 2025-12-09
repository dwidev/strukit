import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../domain/usecase/sign_with_email.dart';

import '../../domain/entities/authorize.dart';
import '../../domain/entities/user_data.dart';
import '../../domain/usecase/authorized_checking.dart';
import '../../domain/usecase/sign_with_google.dart';
import '../../domain/usecase/sign_with_phonenumber.dart';
import '../../domain/usecase/verify_otp.dart';

part 'authentication_event.dart';
part 'authentication_state.dart';
part 'authorize_state.dart';
part 'authentication_otp_bloc.dart';

@Injectable()
class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final SignWithGoogle signWithGoogle;
  final AuthorizedChecking authorizedChecking;
  final SignWithPhoneNumber signWithPhoneNumber;
  final SignWithEmail signWithEmail;

  AuthenticationBloc({
    required this.signWithGoogle,
    required this.authorizedChecking,
    required this.signWithPhoneNumber,
    required this.signWithEmail,
  }) : super(AuthenticationInitial()) {
    on<AuthorizedCheckingEvent>(_doAuthorizeChecking);
    on<SignWithGoogleEvent>(_doSignWithGoogle);
    on<SignWithPhoneNumberEvent>(_doSignPhoneNumber);
    on<SignWithEmailEvent>(_doSignEmail);
  }

  Future<void> _doAuthorizeChecking(
    AuthorizedCheckingEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    await Future.delayed(2.seconds);
    final checking = await authorizedChecking(null);
    checking.fold(
      (left) {
        emit(const AuthorizeSignNotValidOrLogout());
      },
      (data) {
        if (data == AuthorizeResult.signInWithComplete) {
          emit(const AuthorizeSignComplete());
        }

        if (data == AuthorizeResult.signInNotComplete) {
          emit(const AuthorizeSignNotComplete());
        }

        if (data == AuthorizeResult.logout) {
          emit(const AuthorizeSignNotValidOrLogout());
        }
      },
    );
    emit(state.copyWith(isLoading: false));
  }

  Future<void> _doSignWithGoogle(
    SignWithGoogleEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final response = await signWithGoogle(null);

    response.fold(
      (error) {
        log("$error");
        emit(AuthenticationSignError(error: error));
      },
      (data) {
        if (data.authToken.isRegistered) {
          emit(AuthenticationSignSuccess(userData: data));
        } else {
          emit(AuthenticationSignSuccessNotRegistered(userData: data));
        }
      },
    );
  }

  Future<void> _doSignPhoneNumber(
    SignWithPhoneNumberEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final response = await signWithPhoneNumber(event.phoneNumber);

    response.fold(
      (error) {
        emit(AuthenticationSignError(error: error));
      },
      (data) {
        emit(AuthenticationSignSuccess(userData: data));
      },
    );
  }

  Future<void> _doSignEmail(
    SignWithEmailEvent event,
    Emitter<AuthenticationState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));

    final response = await signWithEmail(event.email);

    response.fold(
      (error) {
        emit(AuthenticationSignError(error: error));
      },
      (data) {
        emit(AuthenticationSignSuccess(userData: data));
      },
    );
  }
}
