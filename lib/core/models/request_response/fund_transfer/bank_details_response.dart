// To parse this JSON data, do
//
//     final getBankAccountResponse = getBankAccountResponseFromJson(jsonString);

import 'dart:convert';

GetBankAccountResponse getBankAccountResponseFromJson(String str) => GetBankAccountResponse.fromJson(json.decode(str));

String getBankAccountResponseToJson(GetBankAccountResponse data) => json.encode(data.toJson());

class GetBankAccountResponse {
  GetBankAccountResponse({
    this.response,
  });

  ResponseData? response;

  factory GetBankAccountResponse.fromJson(Map<String, dynamic> json) => GetBankAccountResponse(
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
  List<Datum>? data;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    success: json["success"] == null ? null : json["success"],
    message: json["message"] == null ? null : json["message"],
    data: json["data"] == null ? null : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success == null ? null : success,
    "message": message == null ? null : message,
    "data": data == null ? null : List<dynamic>.from(data!.map((x) => x.toJson())),
  };
}

class Datum {
  Datum({
    this.singxAccountId,
    this.accountNumber,
    this.accountName,
    this.bankCode,
    this.bankName,
  });

  String? singxAccountId;
  String? accountNumber;
  String? accountName;
  String? bankCode;
  String? bankName;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    singxAccountId: json["singxAccountId"] == null ? null : json["singxAccountId"],
    accountNumber: json["accountNumber"] == null ? null : json["accountNumber"],
    accountName: json["accountName"] == null ? null : json["accountName"],
    bankCode: json["bankCode"] == null ? null : json["bankCode"],
    bankName: json["bankName"] == null ? null : json["bankName"],
  );

  Map<String, dynamic> toJson() => {
    "singxAccountId": singxAccountId == null ? null : singxAccountId,
    "accountNumber": accountNumber == null ? null : accountNumber,
    "accountName": accountName == null ? null : accountName,
    "bankCode": bankCode == null ? null : bankCode,
    "bankName": bankName == null ? null : bankName,
  };
}
