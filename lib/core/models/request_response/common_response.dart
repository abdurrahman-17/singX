// To parse this JSON data, do
//
//     final commonResponse = commonResponseFromJson(jsonString);

import 'dart:convert';

CommonResponse commonResponseFromJson(String str) => CommonResponse.fromJson(json.decode(str));

String commonResponseToJson(CommonResponse data) => json.encode(data.toJson());

class CommonResponse {
  CommonResponse({
    this.success,
    this.message,
    this.error,
  });

  bool? success;
  String? message;
  String? error;

  factory CommonResponse.fromJson(Map<String, dynamic> json) => CommonResponse(
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
