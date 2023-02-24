import 'package:cloud_firestore/cloud_firestore.dart';

class OrderModel {
  factory OrderModel.fromDocumentSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return OrderModel(
      id: data!['id'] as int,
      carId: data['carId'] as int,
      userId: data['userId'] as String,
      carName: data['carName'] as String,
      rentalPrice: data['rentalPrice'] as int,
      fillingAddress: data['fillingAddress'] as String,
      returnAddress: data['returnAddress'] as String,
      rentalStartDateTime: (data['rentalStartDateTime'] as Timestamp).toDate(),
      rentalEndDateTime: (data['rentalEndDateTime'] as Timestamp).toDate(),
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int,
      carId: json['carId'] as int,
      userId: json['userId'] as String,
      carName: json['carName'] as String,
      rentalPrice: json['rentalPrice'] as int,
      fillingAddress: json['fillingAddress'] as String,
      returnAddress: json['returnAddress'] as String,
      rentalStartDateTime: (json['rentalStartDateTime'] as Timestamp).toDate(),
      rentalEndDateTime: (json['rentalEndDateTime'] as Timestamp).toDate(),
    );
  }

  OrderModel({
    this.id,
    this.carId,
    this.userId,
    this.carName,
    this.rentalPrice,
    this.fillingAddress,
    this.returnAddress,
    this.rentalStartDateTime,
    this.rentalEndDateTime,
  });

  final String? fillingAddress;
  final String? returnAddress;
  final DateTime? rentalStartDateTime;
  final DateTime? rentalEndDateTime;
  final String? carName;
  final int? rentalPrice;
  final int? id;
  final int? carId;
  final String? userId;

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'carId': carId,
      'userId': userId,
      'carName': carName,
      'rentalPrice': rentalPrice,
      'fillingAddress': fillingAddress,
      'returnAddress': returnAddress,
      'rentalStartDate': rentalStartDateTime,
      'rentalEndDate': rentalEndDateTime,
    };
  }
}
