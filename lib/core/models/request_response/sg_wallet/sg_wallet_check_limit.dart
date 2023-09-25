// To parse this JSON data, do
//
//     final sgWalletTopUpLimitCheck = sgWalletTopUpLimitCheckFromJson(jsonString);

import 'dart:convert';

SgWalletTopUpLimitCheck sgWalletTopUpLimitCheckFromJson(String str) => SgWalletTopUpLimitCheck.fromJson(json.decode(str));

String sgWalletTopUpLimitCheckToJson(SgWalletTopUpLimitCheck data) => json.encode(data.toJson());

class SgWalletTopUpLimitCheck {
  SgWalletTopUpLimitCheck({
    this.success,
    this.message,
  });

  bool? success;
  String? message;

  factory SgWalletTopUpLimitCheck.fromJson(Map<String, dynamic> json) => SgWalletTopUpLimitCheck(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
  };
}
