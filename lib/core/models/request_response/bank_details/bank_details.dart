// To parse this JSON data, do
//
//     final bankDetails = bankDetailsFromJson(jsonString);

import 'dart:convert';

BankDetails bankDetailsFromJson(String str) => BankDetails.fromJson(json.decode(str));

String bankDetailsToJson(BankDetails data) => json.encode(data.toJson());

class BankDetails {
  BankDetails({
    this.response,
  });

  Response? response;

  factory BankDetails.fromJson(Map<String, dynamic> json) => BankDetails(
    response: Response.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "response": response!.toJson(),
  };
}

class Response {
  Response({
    this.success,
    this.message,
    this.remittanceAccount,
    this.walletAccount,
  });

  bool? success;
  String? message;
  List<Account>? remittanceAccount;
  Account? walletAccount;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    success: json["success"],
    message: json["message"],
    remittanceAccount: List<Account>.from(json["Remittance Account"].map((x) => Account.fromJson(x))),
    walletAccount: Account.fromJson(json["Wallet Account"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "Remittance Account": List<dynamic>.from(remittanceAccount!.map((x) => x.toJson())),
    "Wallet Account": walletAccount!.toJson(),
  };
}

class Account {
  Account({
    this.singxAccountId,
    this.accountNumber,
    this.accountName,
    this.bankCode,
    this.bankName,
    this.uenNumber,
  });

  String? singxAccountId;
  String? accountNumber;
  String? accountName;
  String? bankCode;
  String? bankName;
  String? uenNumber;

  factory Account.fromJson(Map<String, dynamic> json) => Account(
    singxAccountId: json["singxAccountId"],
    accountNumber: json["accountNumber"],
    accountName: json["accountName"],
    bankCode: json["bankCode"],
    bankName: json["bankName"],
    uenNumber: json["UEN Number"],
  );

  Map<String, dynamic> toJson() => {
    "singxAccountId": singxAccountId,
    "accountNumber": accountNumber,
    "accountName": accountName,
    "bankCode": bankCode,
    "bankName": bankName,
    "UEN Number": uenNumber,
  };
}
