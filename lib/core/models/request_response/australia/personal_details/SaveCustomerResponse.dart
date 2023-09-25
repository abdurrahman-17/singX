// To parse this JSON data, do
//
//     final saveCustomerResponse = saveCustomerResponseFromJson(jsonString);


import 'dart:convert';

SaveCustomerResponse saveCustomerResponseFromJson(String str) => SaveCustomerResponse.fromJson(json.decode(str));

String saveCustomerResponseToJson(SaveCustomerResponse data) => json.encode(data.toJson());

class SaveCustomerResponse {
  SaveCustomerResponse({
    this.message,
    this.status,
  });

  String? message;
  int? status;

  factory SaveCustomerResponse.fromJson(Map<String, dynamic> json) => SaveCustomerResponse(
    message: json["message"] == null ? null : json["message"],
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "status": status == null ? null : status,
  };
}
