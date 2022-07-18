import 'dart:convert';

import 'package:powerpoint_pro/models/status.dart';

class Package {
  Package({
    required this.id,
    this.title,
    this.amount,
    this.amountString,
    this.status,
  });

  int id;
  String? title;
  dynamic amount;
  String? amountString;
  Status? status;

  factory Package.fromJson(String str) => Package.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Package.fromMap(Map<String, dynamic> json) => Package(
        id: json["id"],
        title: json["title"],
        amount: json["amount"],
        amountString: json["amount_string"],
        status: Status.fromMap(json["status"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "amount": amount,
        "amount_string": amountString,
        "status": status?.toMap(),
      };
}
