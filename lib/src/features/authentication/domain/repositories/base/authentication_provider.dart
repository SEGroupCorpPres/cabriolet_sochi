import 'package:cabriolet_sochi/src/features/authentication/data/models/user_model.dart';
import 'package:cabriolet_sochi/src/features/authentication/domain/repositories/base/base_autentication_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider extends BaseAuthenticationProvider {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @override
  Future<bool> isLoggedIn() async {
    final firebaseUser = _firebaseAuth.currentUser;
    return firebaseUser != null && firebaseUser.uid.isNotEmpty;
  }

  @override
  Future<void> sendOtp({
    required String phoneNumber,
    required PhoneVerificationCompleted phoneVerificationCompleted,
    required PhoneVerificationFailed phoneVerificationFailed,
    required PhoneCodeSent phoneCodeSent,
    required int timeOutOtp,
    required PhoneCodeAutoRetrievalTimeout autoRetrievalTimeout,
    int? forceResendToken,
  }) {
    return _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: phoneVerificationCompleted,
      verificationFailed: phoneVerificationFailed,
      codeSent: phoneCodeSent,
      codeAutoRetrievalTimeout: autoRetrievalTimeout,
      timeout: Duration(seconds: timeOutOtp),
      forceResendingToken: forceResendToken,
    );
  }

  @override
  Future<User?> verifyPhoneNumber({
    required String verificationId,
    required String smsCode,
  }) {
    final AuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    return _firebaseAuth.signInWithCredential(credential).then(
          (value) => value.user,
        );
  }

  @override
  Future<User?> signInWithCredential(AuthCredential credential) {
    return _firebaseAuth.signInWithCredential(credential).then(
          (value) => value.user,
        );
  }

  @override
  Future<void> saveProfile(UserModel user) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user.id)
        .set(
          user.toJson(),
          SetOptions(merge: true),
        )
        .then(
      (value) async {
        final preferences = await SharedPreferences.getInstance();
        await preferences.setString('uid', user.id ?? '');
      },
    );
  }

}
