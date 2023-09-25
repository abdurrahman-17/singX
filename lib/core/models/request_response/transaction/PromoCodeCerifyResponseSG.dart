// To parse this JSON data, do
//
//     final PromoCodeVerifyResponseSG = verifyPromoResponseSgFromJson(jsonString);

import 'dart:convert';

PromoCodeVerifyResponseSG promoCodeVerifyResponseSGFromJson(String str) => PromoCodeVerifyResponseSG.fromJson(json.decode(str));

String promoCodeVerifyResponseSGToJson(PromoCodeVerifyResponseSG data) => json.encode(data.toJson());

class PromoCodeVerifyResponseSG {
  PromoCodeVerifyResponseSG({
    this.responseData,
  });

  ResponseData? responseData;

  factory PromoCodeVerifyResponseSG.fromJson(Map<String, dynamic> json) => PromoCodeVerifyResponseSG(
    responseData: json["response"] == null ? null : ResponseData.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "response": responseData == null ? null : responseData!.toJson(),
  };
}

class ResponseData {
  ResponseData({
    this.success,
    this.message,
    this.error,
  });

  bool? success;
  String? message;
  String? error;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    error: json["error"] == null ? null : json["error"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "error": error == null ? null : error,
  };
}
