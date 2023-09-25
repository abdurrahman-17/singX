// To parse this JSON data, do
//
//     final transferLimitResponse = transferLimitResponseFromJson(jsonString);

import 'dart:convert';

TransferLimitResponse transferLimitResponseFromJson(String str) => TransferLimitResponse.fromJson(json.decode(str));

String transferLimitResponseToJson(TransferLimitResponse data) => json.encode(data.toJson());

class TransferLimitResponse {
  TransferLimitResponse({
    this.response,
  });

  ResponseData? response;

  factory TransferLimitResponse.fromJson(Map<String, dynamic> json) => TransferLimitResponse(
    response: json["response"] == null ? null : ResponseData.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "response": response == null ? null : response!.toJson(),
  };
}

class ResponseData {
  ResponseData({
    this.success,
    this.message,
    this.data,
  });

  bool? success;
  String? message;
  String? data;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : json["data"],
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : data,
  };
}
