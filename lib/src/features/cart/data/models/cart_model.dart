import 'package:cloud_firestore/cloud_firestore.dart';

class CartModel {

  factory CartModel.fromDocumentSnapshot(
      DocumentSnapshot<Map<String, dynamic>> snapshot,
      SnapshotOptions? options,
      ) {
    final data = snapshot.data();

    return CartModel(
      id: data!['id'] as int,
      carId: data['carId'] as int,
      userId: data['userId'] as String,
      fillingAddress: data['fillingAddress'] as String,
      returnAddress: data['returnAddress'] as String,
      rentalStartDateTime: (data['rentalStartDateTime'] as Timestamp).toDate(),
      rentalEndDateTime: (data['rentalEndDateTime'] as Timestamp).toDate(),
    );
  }

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
      id: json['id'] as int,
      carId: json['carId'] as int,
      userId: json['userId'] as String,
      fillingAddress: json['fillingAddress'] as String,
      returnAddress: json['returnAddress'] as String,
      // rentalStartDateTime: (json['rentalStartDateTime'] as Timestamp).toDate(),
      // rentalEndDateTime: (json['rentalEndDateTime'] as Timestamp).toDate(),
    );
  }
  CartModel({
    this.id,
    this.carId,
    this.userId,
    this.fillingAddress,
    this.returnAddress,
    this.rentalStartDateTime,
    this.rentalEndDateTime,
  });

  final String? fillingAddress;
  final String? returnAddress;
  final DateTime? rentalStartDateTime;
  final DateTime? rentalEndDateTime;
  final int? id;
  final int? carId;
  final String? userId;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'carId': carId,
      'userId': userId,
      'fillingAddress': fillingAddress,
      'returnAddress': returnAddress,
      'rentalStartDate': rentalStartDateTime,
      'rentalEndDate': rentalEndDateTime,
    };
  }
}
