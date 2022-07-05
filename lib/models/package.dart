import 'dart:convert';

import 'package:powerpoint_pro/models/status.dart';

class Category {
  Category({
    this.id,
    this.title,
    this.description,
    this.minDuration,
    this.maxDuration,
    this.minSlides,
    this.maxSlides,
    this.amount,
    this.amountString,
    this.status,
  });

  int? id;
  String? title;
  String? description;
  int? minDuration;
  int? maxDuration;
  int? minSlides;
  int? maxSlides;
  int? amount;
  String? amountString;
  Status? status;

  factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        minDuration: json["min_duration"],
        maxDuration: json["max_duration"],
        minSlides: json["min_slides"],
        maxSlides: json["max_slides"],
        amount: json["amount"],
        amountString: json["amount_string"],
        status: Status.fromMap(json["status"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "description": description,
        "min_duration": minDuration,
        "max_duration": maxDuration,
        "min_slides": minSlides,
        "max_slides": maxSlides,
        "amount": amount,
        "amount_string": amountString,
        "status": status?.toMap(),
      };
}
