// To parse this JSON data, do
//
//     final promoCodeVerifyResponse = promoCodeVerifyResponseFromJson(jsonString);

import 'dart:convert';

PromoCodeVerifyResponse promoCodeVerifyResponseFromJson(String str) => PromoCodeVerifyResponse.fromJson(json.decode(str));

String promoCodeVerifyResponseToJson(PromoCodeVerifyResponse data) => json.encode(data.toJson());

class PromoCodeVerifyResponse {
  PromoCodeVerifyResponse({
    this.message,
    this.revisedSingxFee,
    this.status,
  });

  String? message;
  String? revisedSingxFee;
  int? status;

  factory PromoCodeVerifyResponse.fromJson(Map<String, dynamic> json) => PromoCodeVerifyResponse(
    message: json["message"] == null ? null : json["message"],
    revisedSingxFee: json["revisedSingxFee"],
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "revisedSingxFee": revisedSingxFee,
    "status": status == null ? null : status,
  };
}
