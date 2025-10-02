abstract class Failure implements Exception {
  Failure(this.message);
  final String message;

  @override
  String toString() => message;

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Failure && other.message == message;
  }

  @override
  int get hashCode => message.hashCode;
}

class NoMessageFailure extends Failure {
  NoMessageFailure() : super("");
}

class UnknownFailure extends Failure {
  UnknownFailure(super.message);
}
