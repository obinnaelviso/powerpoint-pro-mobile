import 'dart:convert';

import 'package:powerpoint_pro/models/status.dart';

class User {
  User({
    this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.password,
    this.passwordConfirm,
    this.phoneVerified,
    this.emailVerified,
    this.role,
    this.status,
  });

  int? id;
  String firstName;
  String lastName;
  String email;
  String? password;
  String? passwordConfirm;
  String? phoneVerified;
  String? emailVerified;
  String? role;
  Status? status;

  factory User.fromJson(String str) => User.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        email: json["email"],
        password: json["password"],
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
        "password": password,
        "password_confirmation": passwordConfirm,
        "status": status?.toMap(),
      };
}
