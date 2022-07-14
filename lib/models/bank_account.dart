import 'dart:convert';

class BankAccount {
  BankAccount({
    required this.id,
    this.bankName,
    this.accountName,
    this.accountNumber,
  });

  int id;
  String? bankName;
  String? accountName;
  String? accountNumber;

  factory BankAccount.fromJson(String str) =>
      BankAccount.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory BankAccount.fromMap(Map<String, dynamic> json) => BankAccount(
        id: json["id"],
        bankName: json["bank_name"],
        accountName: json["account_name"],
        accountNumber: json["account_number"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "bank_name": bankName,
        "account_name": accountName,
        "account_number": accountNumber,
      };
}
