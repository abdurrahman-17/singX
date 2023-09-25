// To parse this JSON data, do
//
//     final verifyOtpResponse = verifyOtpResponseFromJson(jsonString);

import 'dart:convert';

VerifyOtpResponse verifyOtpResponseFromJson(String str) => VerifyOtpResponse.fromJson(json.decode(str));

String verifyOtpResponseToJson(VerifyOtpResponse data) => json.encode(data.toJson());

class VerifyOtpResponse {
  VerifyOtpResponse({
    this.message,
    this.total,
    this.failtokens,
    this.notificationFailed,
    this.notificationSuccess,
    this.status,
  });

  String? message;
  int? total;
  dynamic failtokens;
  int? notificationFailed;
  int? notificationSuccess;
  int? status;

  factory VerifyOtpResponse.fromJson(Map<String, dynamic> json) => VerifyOtpResponse(
    message: json["message"] == null ? null : json["message"],
    total: json["total"] == null ? null : json["total"],
    failtokens: json["failtokens"],
    notificationFailed: json["notificationFailed"] == null ? null : json["notificationFailed"],
    notificationSuccess: json["notificationSuccess"] == null ? null : json["notificationSuccess"],
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "total": total == null ? null : total,
    "failtokens": failtokens,
    "notificationFailed": notificationFailed == null ? null : notificationFailed,
    "notificationSuccess": notificationSuccess == null ? null : notificationSuccess,
    "status": status == null ? null : status,
  };
}
