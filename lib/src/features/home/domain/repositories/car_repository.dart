import 'package:cabriolet_sochi/src/features/home/data/models/car_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// get car data with model
class CarRepository {
  ///call data without filtering and sorting
  Future<List<CarModel>> getCarData() async {
    final carList = <CarModel>[];
    try {
      final docSnap = await FirebaseFirestore.instance.collection('cars').get();
      for (final car in docSnap.docs) {
        carList.add(CarModel.fromJson(car.data()));
      }
      print(carList.toList());
      return carList;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Failed with error '${e.code}': ${e.message}");
        print(carList.toList());
      }
      return carList;
    } catch (e) {
      print('<---------  error --------->');
      throw Exception(e.toString());
    }
  }

  ///call data with a filter and sort
  Future<List<CarModel>> getCartDataWithFilterAndOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String?>? filterValue = prefs.getStringList('filterValue');
    final orderValue = prefs.getString('orderValue');
    var carList = <CarModel>[];
    try {
      if (orderValue!.isEmpty) {
        final docSnap = await FirebaseFirestore.instance.collection('orders').where('name', whereIn: filterValue).get();
        carList = docSnap.docs.map((e) => e.data() as CarModel).toList();
      } else if (filterValue!.isEmpty) {
        final docSnap = await FirebaseFirestore.instance.collection('orders').orderBy(orderValue).get();
        carList = docSnap.docs.map((e) => e.data() as CarModel).toList();
      } else {
        final docSnap = await FirebaseFirestore.instance.collection('orders').where('name', whereIn: filterValue).orderBy(orderValue).get();
        carList = docSnap.docs.map((e) => e.data() as CarModel).toList();
      }
      print(carList);
      return carList;
    } on FirebaseException catch (e) {
      if (kDebugMode) {
        print("Failed with error '${e.code}': ${e.message}");
      }
      return carList;
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
