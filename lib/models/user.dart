import 'dart:convert';

import 'package:powerpoint_pro/models/status.dart';

class User {
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneVerified,
    required this.emailVerified,
    required this.role,
    required this.status,
  });

  int id;
  String firstName;
  String lastName;
  String email;
  String? phoneVerified;
  String? emailVerified;
  String role;
  Status status;

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        phoneVerified: json["phone_verified"],
        emailVerified: json["email_verified"],
        role: json["role"],
        status: Status.fromMap(json["status"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "email": email,
        "phone_verified": phoneVerified,
        "email_verified": emailVerified,
        "role": role,
        "status": status.toMap(),
      };
}
