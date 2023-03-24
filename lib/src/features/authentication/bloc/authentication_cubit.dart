import 'package:bloc/bloc.dart';
import 'package:cabriolet_sochi/src/features/authentication/data/models/country_code.dart';
import 'package:cabriolet_sochi/src/features/authentication/data/models/user_model.dart';
import 'package:cabriolet_sochi/src/features/authentication/domain/repositories/authentication_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';

part 'authentication_state.dart';

class AuthenticationCubit extends Cubit<AuthenticationState> {
  AuthenticationCubit() : super(const AuthenticationState(status: AuthenticationStatus.initial));

  final _authenticationRepository = AuthenticationRepository();

  void phoneNumberChanged(String phone) {
    emit(
      state.copyWith(
        phoneNumber: phone,
      ),
    );
  }

  void otpChanged(String otp) {
    emit(state.copyWith(otp: otp));
  }

  Future<void> saveUserProfile(UserModel user) async {
    emit(state.copyWith(status: AuthenticationStatus.profileUpdateInProgress));
    await _authenticationRepository.saveProfile(user);
    emit(state.copyWith(status: AuthenticationStatus.profileUpdateComplete));
  }

  Future<void> verifyPhoneNumber() async {
    try {
      final user = await _authenticationRepository.verifyPhoneNumber(
        verificationId: state.verificationId!,
        smsCode: state.otp!,
      );

      if (user != null) {
        emit(state.copyWith(status: AuthenticationStatus.otpVerificationSuccess));
        // SAVE USER TO DATABASE

        emit(state.copyWith(status: AuthenticationStatus.authenticated));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthenticationStatus.exception,
        error: e.toString(),
      ));
    }
  }
  Future<void> sendOtp() async {
    final phoneNumber = state.phoneNumber!;
    print(phoneNumber);
    await _authenticationRepository.sendOtp(
      phoneNumber: phoneNumber,
      phoneVerificationCompleted: phoneVerificationCompleted,
      phoneVerificationFailed: phoneVerificationFailed,
      phoneCodeSent: phoneCodeSent,
      autoRetrievalTimeout: autoRetrievalTimeout,
      timeOutOtp: 120
    );
    emit(state.copyWith(isWaiting: true));
    emit(state.copyWith(status: AuthenticationStatus.isWaitingOtp));
  }

  Future<void> phoneVerificationCompleted(AuthCredential credential) async {
    try {
      final user = await _authenticationRepository.signInWithCredential(credential);
      if (user != null) {
        emit(state.copyWith(status: AuthenticationStatus.otpVerificationSuccess));
        // SAVE USER TO DATABASE

        emit(state.copyWith(status: AuthenticationStatus.authenticated));
      }
    } catch (e) {
      emit(state.copyWith(
        status: AuthenticationStatus.exception,
        error: e.toString(),
      ));
    }
  }

  void phoneVerificationFailed(FirebaseAuthException exception) {
    emit(
      state.copyWith(
        status: AuthenticationStatus.exception,
        error: exception.stackTrace.toString(),
      ),
    );
  }

  void phoneCodeSent(String verificationId, int? forceResendToken) {
    emit(
      state.copyWith(
        verificationId: verificationId,
        forceResendToken: forceResendToken,
        status: AuthenticationStatus.otpSent,
        isWaiting: false,
      ),
    );
  }

  void autoRetrievalTimeout(String verificationId) {
    emit(
      state.copyWith(
        verificationId: verificationId,
      ),
    );
  }
}
