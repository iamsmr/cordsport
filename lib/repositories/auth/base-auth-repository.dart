import 'package:firebase_auth/firebase_auth.dart' as auth;

abstract class BaseAuthRepository {
  Stream<auth.User?> get userChanged;
  // Future<String> verifyPhoneNumber({
  //   required String phoneNumber,
  // });

  Future<auth.User?> continueWithPhone({
    required String verificationId,
    required String smsCode,
  });
  Future<void> logout();
}
