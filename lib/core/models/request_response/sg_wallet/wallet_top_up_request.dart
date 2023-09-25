// To parse this JSON data, do
//
//     final walletTopUpRequest = walletTopUpRequestFromJson(jsonString);

import 'dart:convert';

WalletTopUpRequest walletTopUpRequestFromJson(String str) => WalletTopUpRequest.fromJson(json.decode(str));

String walletTopUpRequestToJson(WalletTopUpRequest data) => json.encode(data.toJson());

class WalletTopUpRequest {
  WalletTopUpRequest({
    this.currencyCode,
    this.paymentType,
    this.amount,
    this.senderId,
  });

  String? currencyCode;
  String? paymentType;
  double? amount;
  String? senderId;

  factory WalletTopUpRequest.fromJson(Map<String, dynamic> json) => WalletTopUpRequest(
    currencyCode: json["currencyCode"] == null ? null : json["currencyCode"],
    paymentType: json["paymentType"] == null ? null : json["paymentType"],
    amount: json["amount"] == null ? null : json["amount"],
    senderId: json["senderId"] == null ? null : json["senderId"],
  );

  Map<String, dynamic> toJson() => {
    "currencyCode": currencyCode == null ? null : currencyCode,
    "paymentType": paymentType == null ? null : paymentType,
    "amount": amount == null ? null : amount,
    "senderId": senderId == null ? null : senderId,
  };
}
