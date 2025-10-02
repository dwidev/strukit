part of 'authentication_bloc.dart';

@Injectable()
class AuthenticationOTPBloc extends AuthenticationBloc {
  final VerifyOTP verifyOTP;

  AuthenticationOTPBloc({
    required this.verifyOTP,
    required super.signWithGoogle,
    required super.authorizedChecking,
    required super.signWithPhoneNumber,
    required super.signWithEmail,
  }) {
    on<VerifyOTPEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));

      final response = await verifyOTP(event.otp);
      response.fold(
        (error) {
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
    });
  }
}
