// To parse this JSON data, do
//
//     final promoCodeVerifyRequest = promoCodeVerifyRequestFromJson(jsonString);

import 'dart:convert';

PromoCodeVerifyRequest promoCodeVerifyRequestFromJson(String str) => PromoCodeVerifyRequest.fromJson(json.decode(str));

String promoCodeVerifyRequestToJson(PromoCodeVerifyRequest data) => json.encode(data.toJson());

class PromoCodeVerifyRequest {
  PromoCodeVerifyRequest({
    this.contactId,
    this.emailId,
    this.promoName,
    this.sendAmount,
    this.receiveAmount,
    this.fromId,
    this.toId,
    this.fromCountryId,
    this.toCountryId,
    this.transferPurposeId,
  });

  int? contactId;
  String? emailId;
  String? promoName;
  double? sendAmount;
  double? receiveAmount;
  String? fromId;
  String? toId;
  int? fromCountryId;
  int? toCountryId;
  int? transferPurposeId;

  factory PromoCodeVerifyRequest.fromJson(Map<String, dynamic> json) => PromoCodeVerifyRequest(
    contactId: json["contactId"] == null ? null : json["contactId"],
    emailId: json["emailId"] == null ? null : json["emailId"],
    promoName: json["promoName"] == null ? null : json["promoName"],
    sendAmount: json["sendAmount"] == null ? null : json["sendAmount"],
    receiveAmount: json["receiveAmount"] == null ? null : json["receiveAmount"],
    fromId: json["fromId"] == null ? null : json["fromId"],
    toId: json["toId"] == null ? null : json["toId"],
    fromCountryId: json["fromCountryId"] == null ? null : json["fromCountryId"],
    toCountryId: json["toCountryId"] == null ? null : json["toCountryId"],
    transferPurposeId: json["transferPurposeId"] == null ? null : json["transferPurposeId"],
  );

  Map<String, dynamic> toJson() => {
    "contactId": contactId == null ? null : contactId,
    "emailId": emailId == null ? null : emailId,
    "promoName": promoName == null ? null : promoName,
    "sendAmount": sendAmount == null ? null : sendAmount,
    "receiveAmount": receiveAmount == null ? null : receiveAmount,
    "fromId": fromId == null ? null : fromId,
    "toId": toId == null ? null : toId,
    "fromCountryId": fromCountryId == null ? null : fromCountryId,
    "toCountryId": toCountryId == null ? null : toCountryId,
    "transferPurposeId": transferPurposeId == null ? null : transferPurposeId,
  };
}
