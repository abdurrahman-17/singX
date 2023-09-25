// To parse this JSON data, do
//
//     final generateOtpResponse = generateOtpResponseFromJson(jsonString);

import 'dart:convert';

GenerateOtpResponse generateOtpResponseFromJson(String str) => GenerateOtpResponse.fromJson(json.decode(str));

String generateOtpResponseToJson(GenerateOtpResponse data) => json.encode(data.toJson());

class GenerateOtpResponse {
  GenerateOtpResponse({
    this.message,
    this.total,
    this.failtokens,
    this.notificationFailed,
    this.notificationSuccess,
    this.status,
    this.response
  });

  String? message;
  int? total;
  dynamic failtokens;
  int? notificationFailed;
  int? notificationSuccess;
  int? status;
  ResponseData? response;

  factory GenerateOtpResponse.fromJson(Map<String, dynamic> json) => GenerateOtpResponse(
    message: json["message"] == null ? null : json["message"],
    total: json["total"] == null ? null : json["total"],
    failtokens: json["failtokens"],
    notificationFailed: json["notificationFailed"] == null ? null : json["notificationFailed"],
    notificationSuccess: json["notificationSuccess"] == null ? null : json["notificationSuccess"],
    status: json["status"] == null ? null : json["status"],
    response: ResponseData.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "total": total == null ? null : total,
    "failtokens": failtokens,
    "notificationFailed": notificationFailed == null ? null : notificationFailed,
    "notificationSuccess": notificationSuccess == null ? null : notificationSuccess,
    "status": status == null ? null : status,
    "response": response!.toJson(),
  };
}

class ResponseData {
  ResponseData({
    this.success,
    this.message,
  });

  bool? success;
  String? message;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    success: json["success"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
  };
}
