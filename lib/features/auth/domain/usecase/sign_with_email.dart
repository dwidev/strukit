import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../core/usecase/failure.dart';
import '../entities/sign_type.dart';
import '../entities/user_data.dart';
import '../repository/authentication_repository.dart';

@LazySingleton()
class SignWithEmail extends BaseUsecase<UserData, String> {
  final AuthenticationRepository authenticationRepository;

  SignWithEmail({required this.authenticationRepository});

  @override
  Future<Either<Failure, UserData>> calling(String params) async {
    final response = await authenticationRepository.signWithPhoneOrEmail(
      data: params,
      signType: SignType.email,
    );
    return Right(response);
  }
}
