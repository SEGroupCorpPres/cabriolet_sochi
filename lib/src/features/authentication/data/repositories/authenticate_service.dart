// import 'package:cabriolet_sochi/src/features/authentication/data/models/user_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class AuthenticationService {
//   FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//   User? firebaseUser;
//   FirebaseFirestore firebaseDatabase = FirebaseFirestore.instance;
//
//   Stream<UserModel> retrieveCurrentUser() {
//     return firebaseAuth.authStateChanges().map((User? user) {
//       if (user != null) {
//         return UserModel(id: user.uid, phoneNumber: user.phoneNumber);
//       } else {
//         return UserModel(id: 'uid');
//       }
//     });
//   }
//
//   Future<void> signInWithPhone({
//     required String phoneNumber,
//     required Function(PhoneAuthCredential) verificationCompleted,
//     required Function(FirebaseAuthException) verificationFailed,
//     required Function(String, int?) codeSent,
//     required Function(String) codeAutoRetrievalTimeout,
//   }) async {
//     try {
//       await firebaseAuth.verifyPhoneNumber(
//         verificationCompleted: verificationCompleted,
//         verificationFailed: verificationFailed,
//         codeSent: codeSent,
//         codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
//         phoneNumber: phoneNumber,
//       );
//     } on FirebaseAuthException catch (e) {
//       throw FirebaseAuthException(code: e.code, message: e.message);
//     }
//   }
//
//   Future<void> signOut() async {
//     return await FirebaseAuth.instance.signOut();
//   }
// }
