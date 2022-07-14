import 'dart:convert';

import 'package:powerpoint_pro/models/status.dart';
import 'package:powerpoint_pro/models/user.dart';

class RequestForm {
  RequestForm({
    required this.id,
    required this.name,
    required this.category,
    this.subCategory,
    required this.topic,
    this.description,
    required this.duration,
    required this.slides,
    required this.phone,
    required this.email,
    this.location,
    this.need,
    required this.amount,
    required this.amountString,
    required this.receiptUrl,
    required this.createdAt,
    required this.status,
    required this.user,
  });

  int id;
  String name;
  String category;
  dynamic subCategory;
  String topic;
  dynamic description;
  dynamic duration;
  dynamic slides;
  String phone;
  String email;
  dynamic location;
  dynamic need;
  dynamic amount;
  String amountString;
  String receiptUrl;
  DateTime createdAt;
  Status status;
  User user;

  factory RequestForm.fromJson(String str) =>
      RequestForm.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RequestForm.fromMap(Map<String, dynamic> json) => RequestForm(
        id: json["id"],
        name: json["name"],
        category: json["category"],
        subCategory: json["sub_category"],
        topic: json["topic"],
        description: json["description"],
        duration: json["duration"],
        slides: json["slides"],
        phone: json["phone"],
        email: json["email"],
        location: json["location"],
        need: json["need"],
        amount: json["amount"],
        amountString: json["amount_string"],
        receiptUrl: json["receipt_url"],
        createdAt: DateTime.parse(json["created_at"]),
        status: Status.fromMap(json["status"]),
        user: User.fromMap(json["user"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "category": category,
        "sub_category": subCategory,
        "topic": topic,
        "description": description,
        "duration": duration,
        "slides": slides,
        "phone": phone,
        "email": email,
        "location": location,
        "need": need,
        "amount": amount,
        "amount_string": amountString,
        "receipt_url": receiptUrl,
        "created_at": createdAt.toIso8601String(),
        "status": status.toMap(),
        "user": user.toMap(),
      };
}
