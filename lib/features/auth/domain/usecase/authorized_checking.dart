import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../core/usecase/failure.dart';
import '../entities/authorize.dart';
import '../repository/authentication_repository.dart';

@LazySingleton()
class AuthorizedChecking extends BaseUsecase<AuthorizeResult, void> {
  final AuthenticationRepository authenticationRepository;

  AuthorizedChecking({required this.authenticationRepository});

  @override
  Future<Either<Failure, AuthorizeResult>> calling(void paramsType) async {
    final result = await authenticationRepository.authorizedChecking();
    return Right(result);
  }
}
