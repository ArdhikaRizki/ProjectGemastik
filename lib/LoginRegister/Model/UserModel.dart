import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String name, email, urlfoto, phoneNumber,role, id;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.urlfoto,
    this.phoneNumber = "",
    required this.role,
  });

  factory UserModel.fromSnapshot(DocumentSnapshot doc) {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    return UserModel(
      id: doc.id,
      name: data['name'] ?? 'Tanpa Nama',
      email: data['email'] ?? '',
      role: data['role'] ?? 'user',
      urlfoto: data['urlfoto'] ?? '',
    );
  }

}
