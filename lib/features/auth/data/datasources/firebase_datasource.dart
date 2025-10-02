import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:injectable/injectable.dart';

abstract class AuthFirebaseDataSource {
  Future<UserCredential> signWithGoogle();
}

@LazySingleton(as: AuthFirebaseDataSource)
class AuthFirebaseDataSourceImpl implements AuthFirebaseDataSource {
  final FirebaseAuth firebaseAuth;

  AuthFirebaseDataSourceImpl({required this.firebaseAuth});

  @override
  Future<UserCredential> signWithGoogle() async {
    try {
      final googleUser = await GoogleSignIn.instance.authenticate(
        scopeHint: ['email'],
      );

      final googleAuth = googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.idToken,
      );

      final result = await firebaseAuth.signInWithCredential(credential);
      return result;
    } catch (_) {
      rethrow;
    }
  }
}
