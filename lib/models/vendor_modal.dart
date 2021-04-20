import 'package:cloud_firestore/cloud_firestore.dart';

class Vendor {
  String name;
  String phoneNumber;
  String address;
  String email;
  List transactions;
  Timestamp createdAt;

  Vendor(
      {required this.address,
      required this.email,
      required this.name,
      required this.phoneNumber,
      required this.transactions,
      required this.createdAt});

  Vendor.fromJson(Map<String, dynamic> json, String id)
      : name = id,
        phoneNumber = json['phoneNumber'],
        address = json['address'],
        email = json['email'],
        transactions = json['transactions'],
        createdAt = json['createdAt'];

  Map<String, dynamic> get toJson => {
        'name': name,
        'phoneNumber': phoneNumber,
        'address': address,
        'email': email,
        'transactions': transactions,
        'createdAt': createdAt
      };
}
