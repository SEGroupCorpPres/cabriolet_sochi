import 'package:cabriolet_sochi/src/features/authentication/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountRepository {
  final _firebaseFirestore = FirebaseFirestore.instance.collection('users');

  Future<Map<String, dynamic>> getUserData() async {
    var user0 = <String, dynamic>{};
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');
    try {
      final documentSnapshot = _firebaseFirestore.doc(uid).withConverter(
            fromFirestore: UserModel.fromDocumentSnapshot,
            toFirestore: (UserModel userModel, _) => userModel.toJson(),
          );

      final docSnap = await documentSnapshot.get();
      final user = docSnap.data();
      if (user != null) {
        user0 = {
          'id': user.id,
          'fullName': user.fullName,
          'imageUrl': user.imageUrl,
          'phoneNumber': user.phoneNumber,
          'dateOfBirth': user.dateOfBirth
        };
        print(user0);
        return user0;
      } else {
        print('No such document.');
        return user0;
      }
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Failed with error '${e.code}': ${e.message}");
      }
      return user0;
    } catch (e) {
      throw Exception(e.toString());
    }
  }


}
