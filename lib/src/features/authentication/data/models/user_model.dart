import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  UserModel({
    this.id,
    this.firstName,
    this.phoneNumber,
    this.imageUrl,
    this.creationDateTimeMillis,
    this.dateOfBirthTimeMillis,
  });

  // UserModel.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
  //     : uid = doc.id,
  //       phoneNumber = doc.data()!['phoneNumber'].toString(),
  //       displayName = doc.data()!['displayName'].toString(),
  //       displayImg = doc.data()!['displayImg'].toString(),
  //       dateBirth = doc.data()!['dateBirth'] as DateTime;
  final String? id, firstName, phoneNumber, imageUrl;
  final int? creationDateTimeMillis, dateOfBirthTimeMillis;

  factory UserModel.fromJson(Map<String, dynamic> data) {
    return UserModel(
      id: data['id'].toString(),
      firstName: data['firstName'].toString(),
      phoneNumber: data['phoneNumber'].toString(),
      imageUrl: data['imageUrl'].toString(),
      creationDateTimeMillis: int.parse(data['creationDateTimeMillis'].toString()),
      dateOfBirthTimeMillis: int.parse(data['dateOfBirthTimeMillis'].toString()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'phoneNumber': phoneNumber,
      'imageUrl': imageUrl,
      'creationDateTimeMillis': creationDateTimeMillis,
      'dateOfBirthTimeMillis': dateOfBirthTimeMillis,
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
