import 'dart:convert';

import 'package:powerpoint_pro/models/status.dart';

class Package {
  Package({
    required this.id,
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

  int id;
  String? title;
  String? description;
  dynamic minDuration;
  dynamic maxDuration;
  dynamic minSlides;
  dynamic maxSlides;
  dynamic amount;
  String? amountString;
  Status? status;

  factory Package.fromJson(String str) => Package.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Package.fromMap(Map<String, dynamic> json) => Package(
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
