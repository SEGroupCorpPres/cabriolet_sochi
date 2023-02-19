import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    this.id,
    this.fullName,
    this.phoneNumber,
    this.imageUrl,
    this.dateOfBirth,
  });

  // factory City.fromFirestore(
  //     DocumentSnapshot<Map<String, dynamic>> snapshot,
  //     SnapshotOptions? options,
  //     ) {
  //   final data = snapshot.data();
  //   return City(
  //     name: data?['name'],
  //     state: data?['state'],
  //     country: data?['country'],
  //     capital: data?['capital'],
  //     population: data?['population'],
  //     regions:
  //     data?['regions'] is Iterable ? List.from(data?['regions']) : null,
  //   );
  // }
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
      // dateOfBirth: data['dateOfBirth'] as DateTime,
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
      dateOfBirth: data['dateOfBirth'] as DateTime,
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

// UserModel copyWith({
//   bool? isVerified,
//   String? uid,
//   String? phoneNumber,
//   String? displayName,
//   String? displayImg,
//   DateTime? dateBirth,
// }) {
//   return UserModel(
//     uid: uid ?? this.uid,
//     phoneNumber: phoneNumber ?? this.phoneNumber,
//     displayName: displayName ?? this.displayName,
//     displayImg: displayImg ?? this.displayImg,
//     isVerified: isVerified ?? this.isVerified,
//     dateBirth: dateBirth ?? this.dateBirth,
//   );
// }
}
