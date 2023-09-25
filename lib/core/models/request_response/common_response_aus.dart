// To parse this JSON data, do
//
//     final CommonResponseAus = CommonResponseAusFromJson(jsonString);

import 'dart:convert';

CommonResponseAus CommonResponseAusFromJson(String str) => CommonResponseAus.fromJson(json.decode(str));

String CommonResponseAusToJson(CommonResponseAus data) => json.encode(data.toJson());

class CommonResponseAus {
  CommonResponseAus({
    this.message,
    this.status,
  });

  String? message;
  int? status;

  factory CommonResponseAus.fromJson(Map<String, dynamic> json) => CommonResponseAus(
    message: json["message"] == null ? null : json["message"],
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "status": status == null ? null : status,
  };
}
