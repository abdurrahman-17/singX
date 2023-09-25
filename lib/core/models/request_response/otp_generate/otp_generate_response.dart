// To parse this JSON data, do
//
//     final otpGenerateResponse = otpGenerateResponseFromJson(jsonString);

import 'dart:convert';

OtpGenerateResponse otpGenerateResponseFromJson(String str) => OtpGenerateResponse.fromJson(json.decode(str));

String otpGenerateResponseToJson(OtpGenerateResponse data) => json.encode(data.toJson());

class OtpGenerateResponse {
  OtpGenerateResponse({
    this.success,
  });

  bool? success;

  factory OtpGenerateResponse.fromJson(Map<String, dynamic> json) => OtpGenerateResponse(
    success: json["success"] == null ? null : json["success"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
  };
}
