import 'package:cabriolet_sochi/src/features/authentication/data/models/user_model.dart';
import 'package:cabriolet_sochi/src/features/authentication/domain/repositories/base/authentication_provider.dart';
import 'package:cabriolet_sochi/src/features/authentication/domain/repositories/base/base_autentication_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationRepository {
  final BaseAuthenticationProvider _authenticationProvider = AuthenticationProvider();

  Future<bool> isLoggedIn() => _authenticationProvider.isLoggedIn();

  Future<void> sendOtp({
    required String phoneNumber,
    required PhoneVerificationCompleted phoneVerificationCompleted,
    required PhoneVerificationFailed phoneVerificationFailed,
    required PhoneCodeSent phoneCodeSent,
    required int timeOutOtp,
    required PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout,
    int? forceResendToken,
  }) =>
      _authenticationProvider.sendOtp(
        phoneNumber: phoneNumber,
        phoneVerificationCompleted: phoneVerificationCompleted,
        phoneVerificationFailed: phoneVerificationFailed,
        phoneCodeSent: phoneCodeSent,
        autoRetrievalTimeout: autoRetrievalTimeout,
        timeOutOtp: timeOutOtp,
      );

  Future<User?> verifyPhoneNumber({
    required String verificationId,
    required String smsCode,
  }) =>
      _authenticationProvider.verifyPhoneNumber(
        verificationId: verificationId,
        smsCode: smsCode,
      );

  Future<User?> signInWithCredential(AuthCredential credential) => _authenticationProvider.signInWithCredential(credential);

  Future<void> saveProfile(UserModel user) => _authenticationProvider.saveProfile(user);
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
}
