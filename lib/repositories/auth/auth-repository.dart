import 'package:codespot/models/models.dart';
import 'package:codespot/repositories/auth/base-auth-repository.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/services.dart';

class AuthRepository extends BaseAuthRepository {
  final auth.FirebaseAuth _firebaseAuth;

  AuthRepository({auth.FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance;

  @override
  Future<void> continueWithPhoneNumber({
    required String phoneNumber,
    required int smsCode,
  }) async {
    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (credential) async {
          await _firebaseAuth.signInWithCredential(credential);
        },
        verificationFailed: (exception) {},
        timeout: const Duration(seconds: 120),
        codeSent: (String verificationId, int? resendToken) async {
          auth.PhoneAuthCredential credential =
              auth.PhoneAuthProvider.credential(
            verificationId: verificationId,
            smsCode: smsCode.toString(),
          );
          await _firebaseAuth.signInWithCredential(credential);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Auto-resolution timed out...
        },
      );
    } on auth.FirebaseAuthException catch (err) {
      throw Failure(
        code: err.code,
        message: err.message ?? "",
      );
    } on PlatformException catch (err) {
      throw Failure(
        code: err.code,
        message: err.message ?? "",
      );
    }
  }

  @override
  Stream<auth.User?> get userChanged => _firebaseAuth.userChanges();

  @override
  Future<void> logout() async {
    await _firebaseAuth.signOut();
  }
}
