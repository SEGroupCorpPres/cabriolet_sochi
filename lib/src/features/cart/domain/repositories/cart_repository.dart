
import 'package:cabriolet_sochi/src/features/cart/data/models/cart_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class CartRepository {
  Future<List> getCartData() async {
  final uid0= FirebaseAuth.instance.currentUser!.uid;
   var cartList = [];
    try {
      print(uid0);
      final docSnap = await FirebaseFirestore.instance.collection('orders').where('userId', isEqualTo: uid0).get();
     cartList = docSnap.docs.map((e) => e.data()).toList();
        print('cartList -------->    ${cartList}');
        return cartList;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Failed with error '${e.code}': ${e.message}");
      }
      return cartList;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
