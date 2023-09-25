// To parse this JSON data, do
//
//     final walletTopUpResponse = walletTopUpResponseFromJson(jsonString);

import 'dart:convert';

WalletTopUpResponse walletTopUpResponseFromJson(String str) => WalletTopUpResponse.fromJson(json.decode(str));

String walletTopUpResponseToJson(WalletTopUpResponse data) => json.encode(data.toJson());

class WalletTopUpResponse {
  WalletTopUpResponse({
    this.bankName,
    this.qrCode,
    this.success,
    this.branchName,
    this.message,
    this.transactionId,
    this.accountName,
    this.accountNumber,
  });

  String? bankName;
  String? qrCode;
  bool? success;
  String? branchName;
  String? message;
  String? transactionId;
  String? accountName;
  String? accountNumber;

  factory WalletTopUpResponse.fromJson(Map<String, dynamic> json) => WalletTopUpResponse(
    bankName: json["BankName"] == null ? null : json["BankName"],
    qrCode: json["QrCode"] == null ? null : json["QrCode"],
    success: json["success"] == null ? null : json["success"],
    branchName: json["BranchName"] == null ? null : json["BranchName"],
    message: json["message"] == null ? null : json["message"],
    transactionId: json["Transaction Id"] == null ? null : json["Transaction Id"],
    accountName: json["AccountName"] == null ? null : json["AccountName"],
    accountNumber: json["AccountNumber"] == null ? null : json["AccountNumber"],
  );

  Map<String, dynamic> toJson() => {
    "BankName": bankName == null ? null : bankName,
    "QrCode": qrCode == null ? null : qrCode,
    "success": success == null ? null : success,
    "BranchName": branchName == null ? null : branchName,
    "message": message == null ? null : message,
    "Transaction Id": transactionId == null ? null : transactionId,
    "AccountName": accountName == null ? null : accountName,
    "AccountNumber": accountNumber == null ? null : accountNumber,
  };
}
