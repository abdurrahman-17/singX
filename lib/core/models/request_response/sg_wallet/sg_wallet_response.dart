// To parse this JSON data, do
//
//     final sgWalletBalance = sgWalletBalanceFromJson(jsonString);

import 'dart:convert';

SgWalletBalance sgWalletBalanceFromJson(String str) => SgWalletBalance.fromJson(json.decode(str));

String sgWalletBalanceToJson(SgWalletBalance data) => json.encode(data.toJson());

class SgWalletBalance {
  SgWalletBalance({
    this.balance,
    this.limit,
  });

  String? balance;
  String? limit;

  factory SgWalletBalance.fromJson(Map<String, dynamic> json) => SgWalletBalance(
    balance: json["balance"] == null ? null : json["balance"],
    limit: json["limit"] == null ? null : json["limit"],
  );

  Map<String, dynamic> toJson() => {
    "balance": balance == null ? null : balance,
    "limit": limit == null ? null : limit,
  };
}
