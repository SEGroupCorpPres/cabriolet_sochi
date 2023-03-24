part of 'authentication_cubit.dart';

enum AuthenticationStatus {
  initial,
  authInProgress,
  otpSent,
  isWaitingOtp,
  pendingOtpVerification,
  otpVerificationSuccess,
  otpVerificationFailure,
  exception,
  authenticated,
  unauthenticated,
  profileUpdateInProgress,
  profileUpdateComplete,
}

class AuthenticationState extends Equatable {
  const AuthenticationState({
    this.status,
    this.error,
    this.phoneNumber,
    this.verificationId,
    this.forceResendToken,
    this.userModel,
    this.country,
    this.otp,
    this.isWaiting,
  });

  final AuthenticationStatus? status;
  final String? error, phoneNumber, verificationId, otp;
  final bool? isWaiting;
  final int? forceResendToken;
  final UserModel? userModel;
  final Country? country;

  AuthenticationState copyWith({
    AuthenticationStatus? status,
    String? error,
    String? phoneNumber,
    String? verificationId,
    int? forceResendToken,
    UserModel? userModel,
    Country? country,
    String? otp,
    bool? isWaiting,
  }) {
    return AuthenticationState(
      status: status ?? this.status,
      error: error ?? this.error,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      verificationId: verificationId ?? this.verificationId,
      forceResendToken: forceResendToken ?? this.forceResendToken,
      userModel: userModel ?? this.userModel,
      country: country ?? this.country,
      otp: otp ?? this.otp,
      isWaiting: isWaiting ?? this.isWaiting,
    );
  }

  @override
  List<Object?> get props => [
        status,
        error,
        phoneNumber,
        verificationId,
        forceResendToken,
        userModel,
        country,
        otp,
        isWaiting,
      ];
}
