// To parse this JSON data, do
//
//     final otpVerifyResponse = otpVerifyResponseFromJson(jsonString);

import 'dart:convert';

OtpVerifyResponse otpVerifyResponseFromJson(String str) => OtpVerifyResponse.fromJson(json.decode(str));

String otpVerifyResponseToJson(OtpVerifyResponse data) => json.encode(data.toJson());

class OtpVerifyResponse {
  OtpVerifyResponse({
    this.success,
    this.documentId,
    this.path
  });

  bool? success;
  String? documentId;
  String? path;
  factory OtpVerifyResponse.fromJson(Map<String, dynamic> json) => OtpVerifyResponse(
    success: json["success"] == null ? null : json["success"],
    documentId: json["documentId"] == null ? null : json["documentId"],
    path: json["path"] == null ? null : json["path"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "documentId": documentId == null ? null : documentId,
    "path": path == null ? null : path,
  };
}
