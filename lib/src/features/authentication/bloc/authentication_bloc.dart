// import 'dart:async';
//
// import 'package:cabriolet_sochi/src/features/authentication/data/datasources/remote/database_repository_impl.dart';
// import 'package:cabriolet_sochi/src/features/authentication/data/models/user_model.dart';
// import 'package:cabriolet_sochi/src/features/authentication/data/repositories/authentication_repository_impl.dart';
// import 'package:cabriolet_sochi/src/features/authentication/domain/repositories/authentication_repository.dart';
// import 'package:equatable/equatable.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
//
// part 'authentication_event.dart';
//
// part 'authentication_state.dart';
//
// class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
//
//   AuthenticationBloc(this._authenticationRepository) : super(AuthenticationInitial()) {
//     on<AuthenticationEvent>((event, emit) async {
//       if (event is AuthenticationStarted) {
//         UserModel user = await _authenticationRepository.getCurrentUser().first;
//         if (user.uid != "uid") {
//           String? phoneNumber = await _authenticationRepository.retrieveUserPhone(user);
//           emit(AuthenticationSuccess(phoneNumber: phoneNumber));
//         } else {
//           emit(AuthenticationFailure(error: ''));
//         }
//       } else if (event is AuthenticationSignedOut) {
//         await _authenticationRepository.signOut();
//         emit(AuthenticationFailure(error: ''));
//       }
//     });
//     on<SentOtpToPhoneEvent>((event, emit) async {
//       emit(AuthenticationLoading());
//       try {
//         await _authenticationRepository.signIn(
//           phoneNumber: event.phoneNumber!,
//           verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
//             add(OnPhoneAuthVerificationCompletedEvent(authCredential: phoneAuthCredential));
//           },
//           verificationFailed: (FirebaseAuthException e) {
//             add(OnPhoneAuthErrorEvent(error: e.toString()));
//           },
//           codeSent: (String verificationId, int? refreshToken) {
//             add(OnPhoneOtpSent(verificationId: verificationId, token: refreshToken));
//           },
//           codeAutoRetrievalTimeout: (String verificationId) {},
//         );
//       } catch (e) {
//         emit(AuthenticationFailure(error: e.toString()));
//       }
//     });
//     on<OnPhoneOtpSent>((event, emit) {
//       emit(PhoneAuthCodeSentSuccess(verificationId: event.verificationId));
//     });
//
//     on<VerifySentOtp>((event, emit) {
//       try {
//         PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
//           verificationId: event.verificationId,
//           smsCode: event.otpCode,
//         );
//         add(OnPhoneAuthVerificationCompletedEvent(authCredential: phoneAuthCredential));
//       } catch (e) {
//         emit(AuthenticationFailure(error: e.toString()));
//       }
//     });
//
//     on<OnPhoneAuthErrorEvent>((event, emit) {
//       emit(AuthenticationFailure(error: event.error.toString()));
//     });
//
//     on<OnPhoneAuthVerificationCompletedEvent>((event, emit) async {
//       try {
//         await _firebaseAuth!.signInWithCredential(event.authCredential!).then((value) {
//           emit(AuthenticationSuccess());
//         });
//       } catch (e) {
//         emit(AuthenticationFailure(error: e.toString()));
//       }
//     });
//   }
//   String signInResult = '';
//   UserCredential? userCredential;
//   FirebaseAuth? _firebaseAuth;
//   DatabaseRepository? _databaseRepository;
//   UserModel? _userModel;
//   final AuthenticationRepository _authenticationRepository;
// }
