import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    this.id,
    this.fullName,
    this.phoneNumber,
    this.imageUrl,
    this.dateOfBirth,
  });

  factory UserModel.fromDocumentSnapshot(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options,
  ) {
    final data = snapshot.data();

    return UserModel(
      id: data!['id'] as String,
      phoneNumber: data['phoneNumber'].toString(),
      fullName: data['fullName'].toString(),
      imageUrl: data['imageUrl'].toString(),
      dateOfBirth: (data['dateOfBirth'] as Timestamp).toDate(),
    );
  }

  final String? id, fullName, phoneNumber, imageUrl;
  final DateTime? dateOfBirth;

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'] as String,
      fullName: data['fullName'] as String,
      phoneNumber: data['phoneNumber'] as String,
      imageUrl: data['imageUrl'] as String,
      dateOfBirth: (data['dateOfBirth'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'dateOfBirth': dateOfBirth,
    };
  }
}
