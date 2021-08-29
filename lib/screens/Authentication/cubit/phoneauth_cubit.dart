import 'package:bloc/bloc.dart';
import 'package:codespot/models/failure.dart';
import 'package:codespot/repositories/repositories.dart';
import 'package:equatable/equatable.dart';

part 'phoneauth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  AuthRepository _authRepository;
  PhoneAuthCubit({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(PhoneAuthState.initial());

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
    try {
      String verificationNum = await _authRepository.verifyPhoneNumber(
        phoneNumber: state.phoneNumber,
      );
      emit(
        state.copyWith(
          verificationNumber: verificationNum,
          status: PhoneAuthStatus.success,
        ),
      );
    } on Failure catch (e) {
      emit(state.copyWith(failure: e, status: PhoneAuthStatus.error));
    }
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
}
