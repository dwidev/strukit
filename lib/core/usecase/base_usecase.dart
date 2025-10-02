import 'package:either_dart/either.dart';

import 'failure.dart';

abstract class BaseUsecase<ReturnType, ParamsType> {
  Future<Either<Failure, ReturnType>> call(ParamsType paramsType) async {
    try {
      final response = await calling(paramsType);
      return response.fold((left) => Left(left), (right) => Right(right));
    } catch (e) {
      if (e is Failure) {
        return Left(e);
      }

      return Left(UnknownFailure(e.toString()));
    }
  }

  Future<Either<Failure, ReturnType>> calling(ParamsType params);
}
