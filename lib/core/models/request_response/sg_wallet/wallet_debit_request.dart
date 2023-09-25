// To parse this JSON data, do
//
//     final walletDebitRequest = walletDebitRequestFromJson(jsonString);

import 'dart:convert';

WalletDebitRequest walletDebitRequestFromJson(String str) => WalletDebitRequest.fromJson(json.decode(str));

String walletDebitRequestToJson(WalletDebitRequest data) => json.encode(data.toJson());

class WalletDebitRequest {
  WalletDebitRequest({
    this.contactId,
    this.countrycode,
    this.currencyCode,
    this.endbal,
    this.exchangeRate,
    this.paymentType,
    this.productTxnId,
    this.sendAmount,
    this.senderId,
    this.startbal,
    this.totalPayable,
    this.transactionFee,
    this.transactionType,
  });

  String? contactId;
  String? countrycode;
  String? currencyCode;
  double? endbal;
  double? exchangeRate;
  String? paymentType;
  String? productTxnId;
  String? sendAmount;
  String? senderId;
  double? startbal;
  String? totalPayable;
  String? transactionFee;
  String? transactionType;

  factory WalletDebitRequest.fromJson(Map<String, dynamic> json) => WalletDebitRequest(
    contactId: json["contactId"] == null ? null : json["contactId"],
    countrycode: json["countrycode"] == null ? null : json["countrycode"],
    currencyCode: json["currencyCode"] == null ? null : json["currencyCode"],
    endbal: json["endbal"] == null ? null : json["endbal"].toDouble(),
    exchangeRate: json["exchangeRate"] == null ? null : json["exchangeRate"],
    paymentType: json["paymentType"] == null ? null : json["paymentType"],
    productTxnId: json["productTxnId"] == null ? null : json["productTxnId"],
    sendAmount: json["sendAmount"] == null ? null : json["sendAmount"],
    senderId: json["senderId"] == null ? null : json["senderId"],
    startbal: json["startbal"] == null ? null : json["startbal"],
    totalPayable: json["totalPayable"] == null ? null : json["totalPayable"],
    transactionFee: json["transactionFee"] == null ? null : json["transactionFee"],
    transactionType: json["transactionType"] == null ? null : json["transactionType"],
  );

  Map<String, dynamic> toJson() => {
    "contactId": contactId == null ? null : contactId,
    "countrycode": countrycode == null ? null : countrycode,
    "currencyCode": currencyCode == null ? null : currencyCode,
    "endbal": endbal == null ? null : endbal,
    "exchangeRate": exchangeRate == null ? null : exchangeRate,
    "paymentType": paymentType == null ? null : paymentType,
    "productTxnId": productTxnId == null ? null : productTxnId,
    "sendAmount": sendAmount == null ? null : sendAmount,
    "senderId": senderId == null ? null : senderId,
    "startbal": startbal == null ? null : startbal,
    "totalPayable": totalPayable == null ? null : totalPayable,
    "transactionFee": transactionFee == null ? null : transactionFee,
    "transactionType": transactionType == null ? null : transactionType,
  };
}
