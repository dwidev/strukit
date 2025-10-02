import 'package:either_dart/either.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/usecase/base_usecase.dart';
import '../../../../core/usecase/failure.dart';
import '../repository/authentication_repository.dart';

@LazySingleton()
class ClearAuthStorage extends BaseUsecase<void, void> {
  final AuthenticationRepository authenticationRepository;

  ClearAuthStorage({required this.authenticationRepository});

  @override
  Future<Either<Failure, void>> calling(void params) async {
    await authenticationRepository.clearAuthStorage();
    return const Right(null);
  }
}
