import 'package:cloud_firestore/cloud_firestore.dart';

class PersonalExpense {
  String id;
  int amount;
  String message;
  Timestamp time;

  PersonalExpense.fromJson(Map<String, dynamic> json, String id)
      : amount = json['amount'],
        message = json['message'],
        time = json['time'],
        id = id;

  PersonalExpense(
      {required this.amount,
      required this.message,
      required this.time,
      required this.id});

  Map<String, dynamic> get toJson =>
      {'amount': amount, 'message': message, 'time': time};
}
