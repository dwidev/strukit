import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:strukit/core/usecase/failure.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../entities/user_data.dart';
import '../repository/authentication_repository.dart';

@LazySingleton()
class VerifyOTP extends BaseUsecase<UserData, String> {
  final AuthenticationRepository authenticationRepository;

  VerifyOTP({required this.authenticationRepository});

  @override
  Future<Either<Failure, UserData>> calling(String params) async {
    final response = await authenticationRepository.verifyOTP(otp: params);
    return Right(response);
  }
}
