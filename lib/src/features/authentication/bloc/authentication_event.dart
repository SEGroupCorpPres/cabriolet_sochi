// part of 'authentication_bloc.dart';
//
// abstract class AuthenticationEvent extends Equatable {
//   const AuthenticationEvent();
//
//   @override
//   List<Object?> get props => [];
// }
//
// class AuthenticationStarted extends AuthenticationEvent {
//   @override
//   List<Object?> get props => [];
// }
//
// class AuthenticationSignedOut extends AuthenticationEvent {
//   @override
//   List<Object?> get props => [];
// }
//
// class SentOtpToPhoneEvent extends AuthenticationEvent {
//   final String? phoneNumber;
//
//   const SentOtpToPhoneEvent({this.phoneNumber});
//
//   @override
//   // TODO: implement props
//   List<Object?> get props => [phoneNumber];
// }
//
// class OnPhoneOtpSent extends AuthenticationEvent {
//   final String verificationId;
//   final int? token;
//
//   OnPhoneOtpSent({required this.verificationId, required this.token});
//
//   @override
//   // TODO: implement props
//   List<Object?> get props => [verificationId, token];
// }
//
// class VerifySentOtp extends AuthenticationEvent {
//   final String otpCode;
//   final String verificationId;
//
//   VerifySentOtp({required this.otpCode, required this.verificationId});
//
//   @override
//   // TODO: implement props
//   List<Object?> get props => [otpCode, verificationId];
// }
//
// class OnPhoneAuthErrorEvent extends AuthenticationEvent {
//   final String error;
//
//   OnPhoneAuthErrorEvent({required this.error});
//
//   @override
//   // TODO: implement props
//   List<Object?> get props => [error];
// }
//
// class OnPhoneAuthVerificationCompletedEvent extends AuthenticationEvent {
//   final AuthCredential? authCredential;
//
//   OnPhoneAuthVerificationCompletedEvent({this.authCredential});
//
//   @override
//   // TODO: implement props
//   List<Object?> get props => [authCredential];
// }
