import 'package:cabriolet_sochi/src/features/home/data/models/car_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class CarRepository {
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
}
