// To parse this JSON data, do
//
//     final bankListByBranchCodeResponse = bankListByBranchCodeResponseFromJson(jsonString);

import 'dart:convert';

BankListByBranchCodeResponse bankListByBranchCodeResponseFromJson(String str) => BankListByBranchCodeResponse.fromJson(json.decode(str));

String bankListByBranchCodeResponseToJson(BankListByBranchCodeResponse data) => json.encode(data.toJson());

class BankListByBranchCodeResponse {
  BankListByBranchCodeResponse({
    this.success,
    this.bank,
  });

  bool? success;
  Bank? bank;

  factory BankListByBranchCodeResponse.fromJson(Map<String, dynamic> json) => BankListByBranchCodeResponse(
    success: json["success"] == null ? null : json["success"],
    bank: json["bank"] == null ? null : Bank.fromJson(json["bank"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "bank": bank == null ? null : bank?.toJson(),
  };
}

class Bank {
  Bank({
    this.name,
    this.branch,
    this.code,
    this.address,
    this.city,
    this.state,
    this.country,
  });

  String? name;
  String? branch;
  String? code;
  String? address;
  String? city;
  String? state;
  String? country;

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
    name: json["name"] == null ? null : json["name"],
    branch: json["branch"] == null ? null : json["branch"],
    code: json["code"] == null ? null : json["code"],
    address: json["address"] == null ? null : json["address"],
    city: json["city"] == null ? null : json["city"],
    state: json["state"] == null ? null : json["state"],
    country: json["country"] == null ? null : json["country"],
  );

  Map<String, dynamic> toJson() => {
    "name": name == null ? null : name,
    "branch": branch == null ? null : branch,
    "code": code == null ? null : code,
    "address": address == null ? null : address,
    "city": city == null ? null : city,
    "state": state == null ? null : state,
    "country": country == null ? null : country,
  };
}
