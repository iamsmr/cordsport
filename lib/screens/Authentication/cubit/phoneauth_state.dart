part of 'auth_cubit.dart';

enum AuthCubitStatus { initial, loading, goToVerification, error, success }

class AuthCubitState extends Equatable {
  final String phoneNumber;
  final String verificationNumber;
  final String? smsCode;
  final Failure failure;
  final AuthCubitStatus status;
  final int? resendToekn;
  final auth.ConfirmationResult? confirmationResult;

  const AuthCubitState({
    required this.phoneNumber,
    required this.verificationNumber,
    required this.smsCode,
    required this.failure,
    required this.status,
    required this.resendToekn,
    required this.confirmationResult,
  });

  bool get isValid => phoneNumber.isNotEmpty && phoneNumber.length > 9;

  static AuthCubitState initial() {
    return AuthCubitState(
      phoneNumber: "",
      verificationNumber: "",
      smsCode: "",
      failure: Failure(),
      confirmationResult: null,
      resendToekn: null,
      status: AuthCubitStatus.initial,
    );
  }

  @override
  List<Object?> get props {
    return [
      phoneNumber,
      verificationNumber,
      smsCode,
      failure,
      status,
      resendToekn,
      confirmationResult,
    ];
  }

  AuthCubitState copyWith({
    String? phoneNumber,
    String? verificationNumber,
    String? smsCode,
    Failure? failure,
    AuthCubitStatus? status,
    int? resendToekn,
    auth.ConfirmationResult? confirmationResult,
  }) {
    return AuthCubitState(
      confirmationResult: confirmationResult ?? this.confirmationResult,
      resendToekn: resendToekn ?? this.resendToekn,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      verificationNumber: verificationNumber ?? this.verificationNumber,
      smsCode: smsCode ?? this.smsCode,
      failure: failure ?? this.failure,
      status: status ?? this.status,
    );
    
  }
}
