// part of 'authentication_bloc.dart';
part of 'authentication_cubit.dart';

// abstract class AuthenticationState extends Equatable {
//   const AuthenticationState();
//
//   @override
//   List<Object?> get props => [];
// }
//
// class AuthenticationInitial extends AuthenticationState {
//   @override
//   List<Object?> get props => [];
// }
//
// class AuthenticationSuccess extends AuthenticationState {
//   final String? phoneNumber;
//
//   const AuthenticationSuccess({
//     this.phoneNumber,
//   });
//
//   @override
//   List<Object?> get props => [phoneNumber];
// }
//
// class AuthenticationLoading extends AuthenticationState {
//   @override
//   // TODO: implement props
//   List<Object?> get props => [];
// }
//
// class AuthenticationFailure extends AuthenticationState {
//   AuthenticationFailure({required this.error});
//
//   final String error;
//   @override
//   List<Object?> get props => [error];
// }
//
// class PhoneAuthCodeSentSuccess extends AuthenticationState {
//   final String? verificationId;
//
//   PhoneAuthCodeSentSuccess({this.verificationId});
//
//   @override
//   // TODO: implement props
//   List<Object?> get props => [verificationId];
// }

enum AuthenticationStatus {
  initial,
  authInProgress,
  otpSent,
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
  });

  final AuthenticationStatus? status;
  final String? error, phoneNumber, verificationId, otp;
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
      ];
}
