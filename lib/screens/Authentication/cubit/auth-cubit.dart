
import 'package:bloc/bloc.dart';
import 'package:codespot/models/failure.dart';
import 'package:codespot/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/foundation.dart';

part 'phoneauth_state.dart';

class AuthCubit extends Cubit<AuthCubitState> {
  AuthRepository _authRepository;
  final auth.FirebaseAuth _firebaseAuth;

  AuthCubit({
    required AuthRepository authRepository,
    auth.FirebaseAuth? firebaseAuth,
  })  : _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance,
        _authRepository = authRepository,
        super(AuthCubitState.initial());

  void phoneNumberChanged(String phoneNumber) {
    emit(
      state.copyWith(
        status: AuthCubitStatus.initial,
        phoneNumber: phoneNumber,
      ),
    );
  }

  // make it better

  void smsCodeChanged(String smsCode) {
    emit(state.copyWith(status: AuthCubitStatus.initial, smsCode: smsCode));
  }

  void verifyPhoneNumber() async {
    if (!state.isValid && state.status == AuthCubitStatus.loading) return;
    emit(state.copyWith(status: AuthCubitStatus.loading));
    String phoneNumber = state.phoneNumber;
    Duration timeOut = const Duration(seconds: 0);
    final verificationFailed = (exp) {
      emit(
        state.copyWith(
          status: AuthCubitStatus.error,
          failure: Failure(message: exp.message),
        ),
      );
    };
    final authCompleted = (authCredential) async {
      await _firebaseAuth.signInWithCredential(authCredential);
    };
    final codeSend = (String verificationId, int? resendToekn) {
      emit(
        state.copyWith(
          verificationNumber: verificationId,
          resendToekn: resendToekn,
          status: AuthCubitStatus.goToVerification,
        ),
      );
    };
    try {
      if (kIsWeb) {
        final confirmationResult = await _authRepository.phoneVerificationWeb(
          phoneNumber: phoneNumber,
          // recaptchaVerifier: auth.RecaptchaVerifier(
          //   container: 'recaptcha',
          //   size: auth.RecaptchaVerifierSize.compact,
          //   theme: auth.RecaptchaVerifierTheme.dark,
          // ),
        );
        emit(state.copyWith(
          confirmationResult: confirmationResult,
          status: AuthCubitStatus.initial,
        ));
      } else {
        await _authRepository.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeOut: timeOut,
          phoneVerificationFailed: verificationFailed,
          phoneVerificationCompleted: authCompleted,
          phoneCodeSent: codeSend,
          autoRetrievalTimeout: (val) {},
        );
      }

      emit(state.copyWith(status: AuthCubitStatus.goToVerification));
    } on Failure catch (e) {
      emit(state.copyWith(failure: e, status: AuthCubitStatus.error));
    }
  }

  void signInWithPhoneNumber() async {
    if (state.smsCode == null && state.status == AuthCubitStatus.loading)
      return;
    emit(state.copyWith(status: AuthCubitStatus.loading));

    try {
      if (kIsWeb) {
        await _authRepository.signInWithPhoneWeb(
          smsCode: state.smsCode!,
          confirmationResult: state.confirmationResult!,
        );
      } else {
        await _authRepository.signInWithPhone(
          verificationId: state.verificationNumber,
          smsCode: state.smsCode!,
        );
      }
      emit(state.copyWith(status: AuthCubitStatus.success));
    } on Failure catch (err) {
      emit(state.copyWith(failure: err, status: AuthCubitStatus.error));
    }
  }

  void loginWithGoogleAcc() async {
    if (!state.isValid && state.status == AuthCubitStatus.loading) return;
    emit(state.copyWith(status: AuthCubitStatus.loading));
    try {
      await _authRepository.loginWithGoogleAccount();
      emit(state.copyWith(status: AuthCubitStatus.success));
    } on Failure catch (e) {
      emit(state.copyWith(failure: e, status: AuthCubitStatus.error));
    }
  }
}
