import 'package:bloc/bloc.dart';
import 'package:codespot/models/failure.dart';
import 'package:codespot/repositories/repositories.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

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
        status: PhoneAuthStatus.initial,
        phoneNumber: phoneNumber,
      ),
    );
  }

  void smsCodeChanged(String smsCode) {
    emit(state.copyWith(status: PhoneAuthStatus.initial, smsCode: smsCode));
  }

  void verifyPhoneNumber() async {
    if (!state.isValid && state.status == PhoneAuthStatus.loading) return;
    emit(state.copyWith(status: PhoneAuthStatus.loading));

    // TODO: later implement in better way

    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: state.phoneNumber,
      verificationCompleted: (credential) async {
        await _firebaseAuth.signInWithCredential(credential);
      },
      verificationFailed: (e) {
        emit(state.copyWith(
          failure: Failure(message: e.message, code: e.code),
          status: PhoneAuthStatus.error,
        ));
      },
      timeout: const Duration(seconds: 60),
      codeSent: (String vId, int? resendToken) async {
        emit(
          state.copyWith(
            verificationNumber: vId,
            status: PhoneAuthStatus.goToVerification,
          ),
        );
      },
      codeAutoRetrievalTimeout: (String vId) {},
    );
  }

  void signInWithPhoneNumber() async {
    if (state.smsCode == null && state.status == PhoneAuthStatus.loading)
      return;
    emit(state.copyWith(status: PhoneAuthStatus.loading));

    try {
      await _authRepository.continueWithPhone(
        verificationId: state.verificationNumber,
        smsCode: state.smsCode!,
      );
      emit(state.copyWith(status: PhoneAuthStatus.success));
    } on Failure catch (e) {
      emit(state.copyWith(failure: e, status: PhoneAuthStatus.error));
    }
  }

  void loginWithGoogleAcc() async {
    if (!state.isValid && state.status == PhoneAuthStatus.loading) return;
    emit(state.copyWith(status: PhoneAuthStatus.loading));
    try {
      await _authRepository.loginWithGoogleAccount();
    } on Failure catch (e) {
      emit(state.copyWith(failure: e, status: PhoneAuthStatus.error));
    }
  }
}
