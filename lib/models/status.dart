import 'dart:convert';

class Status {
  Status({
    required this.id,
    required this.title,
  });

  int id;
  String title;

  factory Status.fromJson(String str) => Status.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Status.fromMap(Map<String, dynamic> json) => Status(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "title": title,
      };
}
