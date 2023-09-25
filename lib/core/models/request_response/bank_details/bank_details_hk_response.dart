// To parse this JSON data, do
//
//     final bankDetailsHkResponse = bankDetailsHkResponseFromJson(jsonString);

import 'dart:convert';

BankDetailsHkResponse bankDetailsHkResponseFromJson(String str) => BankDetailsHkResponse.fromJson(json.decode(str));

String bankDetailsHkResponseToJson(BankDetailsHkResponse data) => json.encode(data.toJson());

class BankDetailsHkResponse {
  BankDetailsHkResponse({
    this.response,
  });

  Response? response;

  factory BankDetailsHkResponse.fromJson(Map<String, dynamic> json) => BankDetailsHkResponse(
    response: json["response"] == null ? null : Response.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "response": response?.toJson(),
  };
}

class Response {
  Response({
    this.success,
    this.message,
    this.data,
  });

  bool? success;
  String? message;
  List<Datum>? data;

  factory Response.fromJson(Map<String, dynamic> json) => Response(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.singxAccountId,
    this.accountNumber,
    this.accountName,
    this.bankCode,
    this.bankName,
    this.branchCode,
  });

  String? singxAccountId;
  String? accountNumber;
  String? accountName;
  String? bankCode;
  String? bankName;
  dynamic branchCode;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    singxAccountId: json["singxAccountId"],
    accountNumber: json["accountNumber"],
    accountName: json["accountName"],
    bankCode: json["bankCode"],
    bankName: json["bankName"],
    branchCode: json["branchCode"],
  );

  Map<String, dynamic> toJson() => {
    "singxAccountId": singxAccountId,
    "accountNumber": accountNumber,
    "accountName": accountName,
    "bankCode": bankCode,
    "bankName": bankName,
    "branchCode": branchCode,
  };
}
