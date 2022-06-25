import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_commerce/utils/constants.dart';

class UserModel {
  String phone;
  String? email, userName;
  Timestamp? lastLoggedIn, registeredOn;

  UserModel(
      {required this.phone,
      this.email,
      this.userName,
      this.lastLoggedIn,
      this.registeredOn});

  Map<String, dynamic> toMap() {
    return {
      'phone': phone,
      'email': email ?? '',
      'user_name': userName ?? '',
      'registered_on': registeredOn ?? Timestamp.now(),
      'last_logged_in': lastLoggedIn ?? Timestamp.now()
    };
  }

  fromMap(Map<String, dynamic> data) {
    return UserModel(
        phone: data['phone'],
        email: data['email'] ?? noEmailFound,
        userName: data['user_name'],
        lastLoggedIn: data['last_logged_in'],
        registeredOn: data['registered_on']);
  }
}
