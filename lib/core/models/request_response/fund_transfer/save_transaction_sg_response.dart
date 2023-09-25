// To parse this JSON data, do
//
//     final saveTransactionResponseSg = saveTransactionResponseSgFromJson(jsonString);

import 'dart:convert';

SaveTransactionResponseSG saveTransactionResponseSgFromJson(String str) => SaveTransactionResponseSG.fromJson(json.decode(str));

String saveTransactionResponseSGToJson(SaveTransactionResponseSG data) => json.encode(data.toJson());

class SaveTransactionResponseSG {
  SaveTransactionResponseSG({
    this.response,
  });

  ResponseData? response;

  factory SaveTransactionResponseSG.fromJson(Map<String, dynamic> json) => SaveTransactionResponseSG(
    response: json["response"] == null ? null : ResponseData.fromJson(json["response"]),
  );

  Map<String, dynamic> toJson() => {
    "response": response?.toJson(),
  };
}

class ResponseData {
  ResponseData({
    this.success,
    this.message,
    this.data,
    this.bankDetails,
  });

  bool? success;
  String? message;
  Data? data;
  List<BankDetail>? bankDetails;

  factory ResponseData.fromJson(Map<String, dynamic> json) => ResponseData(
    success: json["success"],
    message: json["message"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
    bankDetails: json["bank_details"] == null ? [] : List<BankDetail>.from(json["bank_details"]!.map((x) => BankDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "success": success,
    "message": message,
    "data": data?.toJson(),
    "bank_details": bankDetails == null ? [] : List<dynamic>.from(bankDetails!.map((x) => x.toJson())),
  };
}

class BankDetail {
  BankDetail({
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
  String? branchCode;

  factory BankDetail.fromJson(Map<String, dynamic> json) => BankDetail(
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

class Data {
  Data({
    this.singxFee,
    this.userTxnId,
    this.totalPayable,
    this.sendAmount,
    this.transactionId,
  });

  var singxFee;
  String? userTxnId;
  var totalPayable;
  var sendAmount;
  String? transactionId;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    singxFee: json["singxFee"]?.toDouble(),
    userTxnId: json["userTxnId"],
    totalPayable: json["TotalPayable"]?.toDouble(),
    sendAmount: json["sendAmount"],
    transactionId: json["transactionId"],
  );

  Map<String, dynamic> toJson() => {
    "singxFee": singxFee,
    "userTxnId": userTxnId,
    "TotalPayable": totalPayable,
    "sendAmount": sendAmount,
    "transactionId": transactionId,
  };
}
