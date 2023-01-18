import 'package:cabriolet_sochi/src/features/authentication/data/models/user_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class BaseAuthenticationProvider {
  Future<bool> isLoggedIn();


  Future<void> sendOtp({
    required String phoneNumber,
    required PhoneVerificationCompleted phoneVerificationCompleted,
    required PhoneVerificationFailed phoneVerificationFailed,
    required PhoneCodeSent phoneCodeSent,
    required PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout,
    int? forceResendToken,
  });

  Future<User?> verifyPhoneNumber({
    required String verificationId,
    required String smsCode,
  });

  Future<User?> signInWithCredential(AuthCredential credential);

  Future<void> saveProfile(UserModel user);
}
