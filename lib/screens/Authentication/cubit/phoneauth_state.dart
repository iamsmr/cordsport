part of 'auth-cubit.dart';

enum PhoneAuthStatus { initial, loading, goToVerification, error, success }

class AuthCubitState extends Equatable {
  final String phoneNumber;
  final String verificationNumber;
  final String? smsCode;
  final Failure failure;
  final PhoneAuthStatus status;

  const AuthCubitState({
    required this.phoneNumber,
    required this.verificationNumber,
    required this.smsCode,
    required this.failure,
    required this.status,
  });

  bool get isValid => phoneNumber.isNotEmpty && phoneNumber.length > 9;

  static AuthCubitState initial() {
    return AuthCubitState(
      phoneNumber: "",
      verificationNumber: "",
      smsCode: "",
      failure: Failure(),
      status: PhoneAuthStatus.initial,
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
    ];
  }

  AuthCubitState copyWith({
    String? phoneNumber,
    String? verificationNumber,
    String? smsCode,
    Failure? failure,
    PhoneAuthStatus? status,
  }) {
    return AuthCubitState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      verificationNumber: verificationNumber ?? this.verificationNumber,
      smsCode: smsCode ?? this.smsCode,
      failure: failure ?? this.failure,
      status: status ?? this.status,
    );
  }
}
