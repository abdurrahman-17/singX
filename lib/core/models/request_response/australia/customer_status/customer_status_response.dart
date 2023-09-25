// To parse this JSON data, do
//
//     final customerStatusResponse = customerStatusResponseFromJson(jsonString);

import 'dart:convert';

CustomerStatusResponse customerStatusResponseFromJson(String str) => CustomerStatusResponse.fromJson(json.decode(str));

String customerStatusResponseToJson(CustomerStatusResponse data) => json.encode(data.toJson());

class CustomerStatusResponse {
  CustomerStatusResponse({
    this.statusId,
    this.statusCode,
    this.attempts,
    this.customerType,
  });

  int? statusId;
  String? statusCode;
  int? attempts;
  String? customerType;

  factory CustomerStatusResponse.fromJson(Map<String, dynamic> json) => CustomerStatusResponse(
    statusId: json["statusId"] == null ? null : json["statusId"],
    statusCode: json["statusCode"] == null ? null : json["statusCode"],
    attempts: json["attempts"] == null ? null : json["attempts"],
    customerType: json["customerType"] == null ? null : json["customerType"],
  );

  Map<String, dynamic> toJson() => {
    "statusId": statusId == null ? null : statusId,
    "statusCode": statusCode == null ? null : statusCode,
    "attempts": attempts == null ? null : attempts,
    "customerType": customerType == null ? null : customerType,
  };
}
