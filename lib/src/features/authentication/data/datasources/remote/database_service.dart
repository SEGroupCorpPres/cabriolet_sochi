// import 'dart:async';
//
// import 'package:cabriolet_sochi/src/features/authentication/data/models/user_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
//
// class DatabaseService {
//   final FirebaseFirestore _db = FirebaseFirestore.instance;
//   FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//
//   Future<void> addUserData(UserModel userData) async {
//     await _db.collection('Users').doc(userData.uid).set(userData.toMap());
//   }
//
//   Future<List<UserModel>> retrieveUserData() async {
//     final snapshot = await _db.collection('Users').get();
//     return snapshot.docs.map(UserModel.fromDocumentSnapshot).toList();
//   }
//
//   Future<String> retrieveUserName(UserModel user) async {
//     final snapshot = await _db.collection('Users').doc(user.uid).get();
//     return snapshot.data()!['displayName'].toString();
//   }
//
//   Future<String> retrieveUserPhone(UserModel user) async {
//     final snapshot = await _db.collection('Users').doc(user.uid).get();
//     return snapshot.data()!['phoneNumber'].toString();
//   }
//
//   Future<String> retrieveUserImg(UserModel user) async {
//     final snapshot = await _db.collection('Users').doc(user.uid).get();
//     return snapshot.data()!['displayImg'].toString();
//   }
//
//   Future<String> retrieveUserDateBirth(UserModel user) async {
//     final snapshot = await _db.collection('Users').doc(user.uid).get();
//     return snapshot.data()!['dateBirth'].toString();
//   }
//
//   Future<String> addUserToDb(UserModel user) async {
//     await _db.collection('Users').doc(firebaseAuth.currentUser!.uid).set(user.toMap());
//     return 'Success';
//   }
// }
