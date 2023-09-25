// To parse this JSON data, do
//
//     final SaveTransactionRequestSG = SaveTransactionRequestSGFromJson(jsonString);

import 'dart:convert';

SaveTransactionRequestSG SaveTransactionRequestSGFromJson(String str) => SaveTransactionRequestSG.fromJson(json.decode(str));

String SaveTransactionRequestSGToJson(SaveTransactionRequestSG data) => json.encode(data.toJson());

class SaveTransactionRequestSG {
  SaveTransactionRequestSG({
    this.senderId,
    this.receiverId,
    this.receiverRelationShip,
    this.promoCode,
    this.transferMode,
    this.comments,
    this.sendCurrency,
    this.receiveCurrency,
    this.sendAmount,
    this.receivedAmount,
    this.exchangeRate,
    this.oneTimePassword,
    this.transferPurposeId,
    this.otherPurpose,
  });

  String? senderId;
  String? receiverId;
  String? receiverRelationShip;
  String? promoCode;
  String? transferMode;
  String? comments;
  String? sendCurrency;
  String? receiveCurrency;
  String? sendAmount;
  String? receivedAmount;
  String? exchangeRate;
  String? oneTimePassword;
  String? transferPurposeId;
  String? otherPurpose;

  factory SaveTransactionRequestSG.fromJson(Map<String, dynamic> json) => SaveTransactionRequestSG(
    senderId: json["senderId"] == null ? null : json["senderId"],
    receiverId: json["receiverId"] == null ? null : json["receiverId"],
    receiverRelationShip: json["receiverRelationShip"] == null ? null : json["receiverRelationShip"],
    promoCode: json["promoCode"] == null ? null : json["promoCode"],
    transferMode: json["transferMode"] == null ? null : json["transferMode"],
    comments: json["comments"] == null ? null : json["comments"],
    sendCurrency: json["sendCurrency"] == null ? null : json["sendCurrency"],
    receiveCurrency: json["receiveCurrency"] == null ? null : json["receiveCurrency"],
    sendAmount: json["sendAmount"] == null ? null : json["sendAmount"],
    receivedAmount: json["receivedAmount"] == null ? null : json["receivedAmount"],
    exchangeRate: json["exchangeRate"] == null ? null : json["exchangeRate"],
    oneTimePassword: json["oneTimePassword"] == null ? null : json["oneTimePassword"],
    transferPurposeId: json["transferPurposeId"] == null ? null : json["transferPurposeId"],
    otherPurpose: json["otherPurpose"] == null ? null : json["otherPurpose"],
  );

  Map<String, dynamic> toJson() => {
    "senderId": senderId == null ? null : senderId,
    "receiverId": receiverId == null ? null : receiverId,
    "receiverRelationShip": receiverRelationShip == null ? null : receiverRelationShip,
    "promoCode": promoCode == null ? null : promoCode,
    "transferMode": transferMode == null ? null : transferMode,
    "comments": comments == null ? null : comments,
    "sendCurrency": sendCurrency == null ? null : sendCurrency,
    "receiveCurrency": receiveCurrency == null ? null : receiveCurrency,
    "sendAmount": sendAmount == null ? null : sendAmount,
    "receivedAmount": receivedAmount == null ? null : receivedAmount,
    "exchangeRate": exchangeRate == null ? null : exchangeRate,
    "oneTimePassword": oneTimePassword == null ? null : oneTimePassword,
    "transferPurposeId": transferPurposeId == null ? null : transferPurposeId,
    "otherPurpose": otherPurpose == null ? null : otherPurpose,
  };
}
