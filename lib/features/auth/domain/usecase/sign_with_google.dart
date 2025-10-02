import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';
import 'package:strukit/core/usecase/base_usecase.dart';
import 'package:strukit/core/usecase/failure.dart';
import 'package:strukit/features/auth/domain/entities/user_data.dart';
import 'package:strukit/features/auth/domain/repository/authentication_repository.dart';

@lazySingleton
class SignWithGoogle extends BaseUsecase<UserData, void> {
  final AuthenticationRepository authenticationRepository;

  SignWithGoogle({required this.authenticationRepository});

  @override
  Future<Either<Failure, UserData>> calling(void params) async {
    final response = await authenticationRepository.signWithGoogle();
    return Right(response);
  }
}
