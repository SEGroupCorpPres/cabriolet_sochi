import 'package:cabriolet_sochi/src/features/orders/data/models/order_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderRepository {
  final _firebaseFirestore = FirebaseFirestore.instance.collection('orders');

  Future<Map<String, dynamic>> getOrder() async {
    var user0 = <String, dynamic>{};
    final prefs = await SharedPreferences.getInstance();
    final uid = prefs.getString('uid');
    try {
      final documentSnapshot = _firebaseFirestore.doc(uid).withConverter(
            fromFirestore: OrderModel.fromDocumentSnapshot,
            toFirestore: (OrderModel orderModel, _) => orderModel.toJson(),
          );

      final docSnap = await documentSnapshot.get();
      final orders = docSnap.data();
      if (orders != null) {
        user0 = {
          'id': orders.id,
          'carId': orders.carId,
          'carName': orders.carName,
          'rentalPrice': orders.rentalPrice,
          'fillingAddress': orders.fillingAddress,
          'returnAddress': orders.returnAddress,
          'rentalStartDate': orders.rentalStartDateTime,
          'rentalEndDate': orders.rentalEndDateTime,

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

  Future<void> saveOrders(OrderModel orderModel, String orderId) async {
    return FirebaseFirestore.instance.collection('orders').doc(orderId).set(
          orderModel.toJson(),
          SetOptions(merge: true),
        );
  }
}
