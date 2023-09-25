// To parse this JSON data, do
//
//     final sgFileUploadResponse = sgFileUploadResponseFromJson(jsonString);

import 'dart:convert';

SgFileUploadResponse sgFileUploadResponseFromJson(String str) => SgFileUploadResponse.fromJson(json.decode(str));

String sgFileUploadResponseToJson(SgFileUploadResponse data) => json.encode(data.toJson());

class SgFileUploadResponse {
  SgFileUploadResponse({
    this.success,
    this.message,
  });

  bool? success;
  String? message;

  factory SgFileUploadResponse.fromJson(Map<String, dynamic> json) => SgFileUploadResponse(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
  };
}
