// To parse this JSON data, do
//
//     final initiateTransferEmailRequest = initiateTransferEmailRequestFromJson(jsonString);

import 'dart:convert';

InitiateTransferEmailRequest initiateTransferEmailRequestFromJson(String str) => InitiateTransferEmailRequest.fromJson(json.decode(str));

String initiateTransferEmailRequestToJson(InitiateTransferEmailRequest data) => json.encode(data.toJson());

class InitiateTransferEmailRequest {
  InitiateTransferEmailRequest({
    this.contactId,
    this.exchangeRate,
    this.receiveAmount,
    this.receiveCurrency,
    this.receiverAccountNumber,
    this.receiverBankName,
    this.receiverName,
    this.sendAmount,
    this.sendCurrency,
    this.singxFee,
    this.totalPayable,
    this.transfermodeId,
    this.userTxnId,
  });

  int? contactId;
  String? exchangeRate;
  String? receiveAmount;
  String? receiveCurrency;
  String? receiverAccountNumber;
  String? receiverBankName;
  String? receiverName;
  String? sendAmount;
  String? sendCurrency;
  String? singxFee;
  String? totalPayable;
  int? transfermodeId;
  String? userTxnId;

  factory InitiateTransferEmailRequest.fromJson(Map<String, dynamic> json) => InitiateTransferEmailRequest(
    contactId: json["contactId"] == null ? null : json["contactId"],
    exchangeRate: json["exchangeRate"] == null ? null : json["exchangeRate"],
    receiveAmount: json["receiveAmount"] == null ? null : json["receiveAmount"],
    receiveCurrency: json["receiveCurrency"] == null ? null : json["receiveCurrency"],
    receiverAccountNumber: json["receiverAccountNumber"] == null ? null : json["receiverAccountNumber"],
    receiverBankName: json["receiverBankName"] == null ? null : json["receiverBankName"],
    receiverName: json["receiverName"] == null ? null : json["receiverName"],
    sendAmount: json["sendAmount"] == null ? null : json["sendAmount"],
    sendCurrency: json["sendCurrency"] == null ? null : json["sendCurrency"],
    singxFee: json["singxFee"] == null ? null : json["singxFee"],
    totalPayable: json["totalPayable"] == null ? null : json["totalPayable"],
    transfermodeId: json["transfermodeId"] == null ? null : json["transfermodeId"],
    userTxnId: json["userTxnId"] == null ? null : json["userTxnId"],
  );

  Map<String, dynamic> toJson() => {
    "contactId": contactId == null ? null : contactId,
    "exchangeRate": exchangeRate == null ? null : exchangeRate,
    "receiveAmount": receiveAmount == null ? null : receiveAmount,
    "receiveCurrency": receiveCurrency == null ? null : receiveCurrency,
    "receiverAccountNumber": receiverAccountNumber == null ? null : receiverAccountNumber,
    "receiverBankName": receiverBankName == null ? null : receiverBankName,
    "receiverName": receiverName == null ? null : receiverName,
    "sendAmount": sendAmount == null ? null : sendAmount,
    "sendCurrency": sendCurrency == null ? null : sendCurrency,
    "singxFee": singxFee == null ? null : singxFee,
    "totalPayable": totalPayable == null ? null : totalPayable,
    "transfermodeId": transfermodeId == null ? null : transfermodeId,
    "userTxnId": userTxnId == null ? null : userTxnId,
  };
}
