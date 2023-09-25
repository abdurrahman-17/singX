// To parse this JSON data, do
//
//     final branchCodeValidationResponse = branchCodeValidationResponseFromJson(jsonString);

import 'dart:convert';

BranchCodeValidationResponse branchCodeValidationResponseFromJson(String str) => BranchCodeValidationResponse.fromJson(json.decode(str));

String branchCodeValidationResponseToJson(BranchCodeValidationResponse data) => json.encode(data.toJson());

class BranchCodeValidationResponse {
  BranchCodeValidationResponse({
    this.success,
    this.errors,
    this.bank,
  });

  bool? success;
  List<dynamic>? errors;
  Bank? bank;

  factory BranchCodeValidationResponse.fromJson(Map<String, dynamic> json) => BranchCodeValidationResponse(
    success: json["success"],
    errors: json["errors"] == null ? [] : List<dynamic>.from(json["errors"]!.map((x) => x)),
    bank: json["bank"] == null ? null : Bank.fromJson(json["bank"]),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "errors": errors == null ? [] : List<dynamic>.from(errors!.map((x) => x)),
    "bank": bank?.toJson(),
  };
}

class Bank {
  Bank({
    this.name,
    this.code,
    this.address,
  });

  String? name;
  String? code;
  String? address;

  factory Bank.fromJson(Map<String, dynamic> json) => Bank(
    name: json["name"],
    code: json["code"],
    address: json["address"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "code": code,
    "address": address,
  };
}
