import 'dart:convert';

import 'package:project_ppt_pro/models/status.dart';

class Category {
  Category({
    required this.id,
    required this.title,
    this.description,
    this.status,
  });

  int id;
  String title;
  String? description;
  Status? status;

  factory Category.fromJson(String str) => Category.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Category.fromMap(Map<String, dynamic> json) => Category(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        status: Status.fromMap(json["status"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
        "description": description,
        "status": status?.toMap(),
      };
}
