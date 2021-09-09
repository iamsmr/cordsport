import 'package:firebase_auth/firebase_auth.dart' as auth;

abstract class BaseAuthRepository {
  Stream<auth.User?> get userChanged;

  // Future<String> verifyPhoneNumber({
  //   required String phoneNumber,
  // });

  Future<auth.User?> signInWithPhone({
    required String verificationId,
    required String smsCode,
  });
  Future<auth.User?> signInWithPhoneWeb({
    required String smsCode,
    required auth.ConfirmationResult confirmationResult,
  });
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Duration timeOut,
    required auth.PhoneVerificationFailed phoneVerificationFailed,
    required auth.PhoneVerificationCompleted phoneVerificationCompleted,
    required auth.PhoneCodeSent phoneCodeSent,
    required auth.PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout,
  });
  Future<auth.ConfirmationResult> phoneVerificationWeb({
    required String phoneNumber,
    auth.RecaptchaVerifier? recaptchaVerifier,
  });

  Future<auth.User?> loginWithGoogleAccount();

  Future<void> logout();
}
