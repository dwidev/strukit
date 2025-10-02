import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:strukit/core/usecase/failure.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../entities/sign_type.dart';
import '../entities/user_data.dart';
import '../repository/authentication_repository.dart';

@LazySingleton()
class SignWithPhoneNumber extends BaseUsecase<UserData, String> {
  final AuthenticationRepository authenticationRepository;

  SignWithPhoneNumber({required this.authenticationRepository});

  @override
  Future<Either<Failure, UserData>> calling(String params) async {
    final response = await authenticationRepository.signWithPhoneOrEmail(
      data: params,
      signType: SignType.phoneNumber,
    );
    return Right(response);
  }
}
