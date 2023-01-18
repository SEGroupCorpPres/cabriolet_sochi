// import 'package:cabriolet_sochi/src/features/authentication/data/datasources/remote/database_service.dart';
// import 'package:cabriolet_sochi/src/features/authentication/data/models/user_model.dart';
// import 'package:cabriolet_sochi/src/features/authentication/data/repositories/authenticate_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class AuthenticationRepositoryImpl implements AuthenticationRepository {
//   AuthenticationService service = AuthenticationService();
//   DatabaseService dbService = DatabaseService();
//
//   @override
//   Stream<UserModel> getCurrentUser() {
//     return service.retrieveCurrentUser();
//   }
//
//   @override
//   Future<String> signUp(UserModel user) {
//     try {
//       return dbService.addUserToDb(user);
//     } on FirebaseAuthException catch (e) {
//       throw FirebaseAuthException(code: e.code, message: e.message);
//     }
//   }
//
//   @override
//   Future<void> signIn({
//     required String phoneNumber,
//     required Function(PhoneAuthCredential) verificationCompleted,
//     required Function(FirebaseAuthException) verificationFailed,
//     required Function(String, int?) codeSent,
//     required Function(String) codeAutoRetrievalTimeout,
//   }) {
//     try {
//       return service.signInWithPhone(
//         phoneNumber: phoneNumber,
//         codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
//         codeSent: codeSent,
//         verificationCompleted: verificationCompleted,
//         verificationFailed: verificationFailed,
//       );
//     } on FirebaseAuthException catch (e) {
//       throw FirebaseAuthException(code: e.code, message: e.message);
//     }
//   }
//
//   @override
//   Future<void> signOut() {
//     return service.signOut();
//   }
//
//   @override
//   Future<String?> retrieveUserName(UserModel user) {
//     return dbService.retrieveUserName(user);
//   }
//
//   @override
//   Future<String?> retrieveUserImg(UserModel user) {
//     return dbService.retrieveUserImg(user);
//   }
//
//   @override
//   Future<String?> retrieveUserPhone(UserModel user) {
//     return dbService.retrieveUserPhone(user);
//   }
//
//   @override
//   Future<String?> retrieveUserDateBirth(UserModel user) {
//     return dbService.retrieveUserDateBirth(user);
//   }
// }
//
// abstract class AuthenticationRepository {
//   Stream<UserModel> getCurrentUser();
//
//   Future<String?> signUp(UserModel user);
//
//   Future<void> signIn({
//     required String phoneNumber,
//     required Function(PhoneAuthCredential) verificationCompleted,
//     required Function(FirebaseAuthException) verificationFailed,
//     required Function(String, int?) codeSent,
//     required Function(String) codeAutoRetrievalTimeout,
//   });
//
//   Future<void> signOut();
//
//   Future<String?> retrieveUserName(UserModel user);
//
//   Future<String?> retrieveUserImg(UserModel user);
//
//   Future<String?> retrieveUserPhone(UserModel user);
//
//   Future<String?> retrieveUserDateBirth(UserModel user);
// }
