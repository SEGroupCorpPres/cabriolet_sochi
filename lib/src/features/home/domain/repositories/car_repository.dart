import 'dart:collection';
import 'dart:convert';

import 'package:cabriolet_sochi/src/features/home/data/models/car_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

/// get car data with model
class CarRepository {
  String endpoint = 'https://cabrioletsochi.ru/json-api';

  Future<List<CarModel>> getData() async {
    final carList = <CarModel>[];
    final response = await http.get(Uri.parse(endpoint));
    try {
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        if (kDebugMode) {
          print(' result  -----> ${result[1]['deposite'].toString().replaceAll(' ', '')}');
        }
        for (final car in result as Iterable<dynamic>) {
          carList.add(CarModel.fromJson(car as Map<String, dynamic>));
        }
        if (kDebugMode) {
          print(' result  -----> ${carList[0]}');
        }
        return carList;
      } else {
        if (kDebugMode) {
          print('response phrase');
        }
        throw Exception(response.reasonPhrase);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
      return carList;
    }
  }

  Future<List<CarModel>> getDataWithFilterAndOrder({required String? orderValues, required List<String?>? filterValues}) async {
    final preferences = await SharedPreferences.getInstance();
    final orderValue = preferences.getString('orderValue');
    final filterValue = preferences.getStringList('filterValue');
    final response = await http.get(Uri.parse(endpoint));
    var carList = <CarModel>[];
    if (kDebugMode) {
      print('get filterValue ----> $filterValue');
    }
    if (kDebugMode) {
      print('get orderValue ---->$orderValue');
    }
    try {
      if (response.statusCode == 200) {
        final result = jsonDecode(response.body) as List;
        if (orderValue == null && filterValue == null || orderValue!.isEmpty && filterValue!.isEmpty) {
          for (final car in result) {
            carList.add(CarModel.fromJson(car as Map<String, dynamic>));
          }
          return carList;
        }
        if (filterValue!.isNotEmpty && orderValue.isEmpty) {
          return result
              .map((item) => CarModel.fromJson(item as Map<String, dynamic>))
              .where(
                (element) => filterValue.contains(
                  element.name!.toUpperCase(),
                ),
              )
              .toList();
        } else if (orderValue.isNotEmpty && filterValue.isEmpty) {
          for (final car in result) {
            carList.add(CarModel.fromJson(car as Map<String, dynamic>));
          }
          switch (orderValue) {
            case 'rentalPrice':
              carList.sort((a, b) => b.rentalPrice!.compareTo(a.rentalPrice!));
              return carList;
            case 'year':
              carList.sort((a, b) => b.year!.compareTo(a.year!));
              return carList;
            case 'output':
              carList.sort((a, b) => b.output!.compareTo(a.output!));
              return carList;
            case 'personCount':
              carList.sort((a, b) => b.personCount!.compareTo(a.personCount!));
              return carList;
            case 'color':
              carList.sort((a, b) => b.color!.compareTo(a.color!));
              return carList;
            default:
              return carList;
          }
        } else {
          carList = result
              .map((item) => CarModel.fromJson(item as Map<String, dynamic>))
              .where(
                (element) => filterValue.contains(
                  element.name!.toUpperCase(),
                ),
              )
              .toList();
          switch (orderValue) {
            case 'rentalPrice':
              carList.sort((a, b) => b.rentalPrice!.compareTo(a.rentalPrice!));
              return carList;
            case 'year':
              carList.sort((a, b) => b.year!.compareTo(a.year!));
              return carList;
            case 'output':
              carList.sort((a, b) => b.output!.compareTo(a.output!));
              return carList;
            case 'personCount':
              carList.sort((a, b) => b.personCount!.compareTo(a.personCount!));
              return carList;
            case 'color':
              carList.sort((a, b) => b.color!.compareTo(a.color!));
              return carList;
            default:
              return carList;
          }
        }
      } else {
        throw Exception('Exception errrrrroooooooooorrrr   ${response.reasonPhrase}');
      }
    } catch (e) {
      throw Exception('throw Exception $e');
    }
  }

  ///call data without filtering and sorting on Firebase
//   Future<List<CarModel>> getCarData() async {
//     final carList = <CarModel>[];
//     try {
//       final docSnap = await FirebaseFirestore.instance.collection('cars').get();
//       for (final car in docSnap.docs) {
//         carList.add(CarModel.fromJson(car.data()));
//       }
//       print(carList.toList());
//       return carList;
//     } on FirebaseException catch (e) {
//       if (kDebugMode) {
//         print("Failed with error '${e.code}': ${e.message}");
//         print(carList.toList());
//       }
//       return carList;
//     } catch (e) {
//       print('<---------  error --------->');
//       throw Exception(e.toString());
//     }
//   }
//
//   ///call data with a filter and sort
//   Future<List<CarModel>> getCartDataWithFilterAndOrder({String? orderValue, List<String?>? filterValue}) async {
//     // final prefs = await SharedPreferences.getInstance();
//     // final List<String?>? filterValue = prefs.getStringList('filterValue');
//     // final orderValue = prefs.getString('orderValue');
//     var carList = <CarModel>[];
//     try {
//       if (orderValue!.isEmpty) {
//         final docSnap = await FirebaseFirestore.instance.collection('orders').where('name', whereIn: filterValue).get();
//         carList = docSnap.docs.map((e) => e.data() as CarModel).toList();
//       } else if (filterValue!.isEmpty) {
//         final docSnap = await FirebaseFirestore.instance.collection('orders').orderBy(orderValue).get();
//         carList = docSnap.docs.map((e) => e.data() as CarModel).toList();
//       } else {
//         final docSnap = await FirebaseFirestore.instance.collection('orders').where('name', whereIn: filterValue).orderBy(orderValue).get();
//         carList = docSnap.docs.map((e) => e.data() as CarModel).toList();
//       }
//       print(carList);
//       return carList;
//     } on FirebaseException catch (e) {
//       if (kDebugMode) {
//         print("Failed with error '${e.code}': ${e.message}");
//       }
//       return carList;
//     } catch (e) {
//       throw Exception(e.toString());
//     }
//   }
}
