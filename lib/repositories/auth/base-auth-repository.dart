import 'package:firebase_auth/firebase_auth.dart' as auth;

abstract class BaseAuthRepository {
  Stream<auth.User?> get userChanged;
  Future<void> continueWithPhoneNumber({
    required String phoneNumber,
    required int smsCode,
  });

  Future<void> logout();
}
