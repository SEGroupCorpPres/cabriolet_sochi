import 'package:cabriolet_sochi/src/features/authentication/data/models/user_model.dart';
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
      userModel: data['userModel'] as Map<String, dynamic>,
      rentalPrice: data['rentalPrice'] as int,
      fillingAddress: data['fillingAddress'] as String,
      returnAddress: data['returnAddress'] as String,
      rentalStartDateTime: (data['rentalStartDateTime'] as Timestamp).toDate(),
      rentalEndDateTime: (data['rentalEndDateTime'] as Timestamp).toDate(),
      orderCreatedTime: (data['orderCreatedTime'] as Timestamp).toDate(),
    );
  }

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] as int,
      carId: json['carId'] as int,
      userId: json['userId'] as String,
      carName: json['carName'] as String,
      rentalPrice: json['rentalPrice'] as int,
      userModel: json['userModel'] as Map<String, dynamic>,
      fillingAddress: json['fillingAddress'] as String,
      returnAddress: json['returnAddress'] as String,
      rentalStartDateTime: (json['rentalStartDateTime'] as Timestamp).toDate(),
      rentalEndDateTime: (json['rentalEndDateTime'] as Timestamp).toDate(),
      orderCreatedTime: (json['orderCreatedTime'] as Timestamp).toDate(),
    );
  }

  OrderModel({
    this.id,
    this.carId,
    this.userId,
    this.carName,
    this.userModel,
    this.rentalPrice,
    this.fillingAddress,
    this.returnAddress,
    this.rentalStartDateTime,
    this.rentalEndDateTime,
    this.orderCreatedTime,
  });

  final String? fillingAddress;
  final String? returnAddress;
  final DateTime? rentalStartDateTime;
  final DateTime? rentalEndDateTime;
  final DateTime? orderCreatedTime;
  final String? carName;
  final int? rentalPrice;
  final int? id;
  final int? carId;
  final String? userId;
  final Map<String, dynamic>? userModel;

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
      'userModel': userModel,
      'orderCreatedTime': orderCreatedTime,
    };
  }
}
