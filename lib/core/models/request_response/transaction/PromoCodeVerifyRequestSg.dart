// To parse this JSON data, do
//
//     final promoCodeVerifyRequestSg = promoCodeVerifyRequestSgFromJson(jsonString);

import 'dart:convert';

PromoCodeVerifyRequestSg promoCodeVerifyRequestSgFromJson(String str) => PromoCodeVerifyRequestSg.fromJson(json.decode(str));

String promoCodeVerifyRequestSgToJson(PromoCodeVerifyRequestSg data) => json.encode(data.toJson());

class PromoCodeVerifyRequestSg {
  PromoCodeVerifyRequestSg({
    this.fromCountryId,
    this.toCountryId,
    this.promoCode,
    this.transferPurposeId,
    this.sendAmt,
    this.receiveAmt,
  });

  String? fromCountryId;
  String? toCountryId;
  String? promoCode;
  int? transferPurposeId;
  String? sendAmt;
  String? receiveAmt;

  factory PromoCodeVerifyRequestSg.fromJson(Map<String, dynamic> json) => PromoCodeVerifyRequestSg(
    fromCountryId: json["corridorId"] == null ? null : json["fromCountryId"],
    toCountryId: json["toCountryId"] == null ? null : json["toCountryId"],
    promoCode: json["promoCode"] == null ? null : json["promoCode"],
    transferPurposeId: json["transferPurposeId"] == null ? null : json["transferPurposeId"],
    sendAmt: json["sendAmt"] == null ? null : json["sendAmt"],
    receiveAmt: json["receiveAmt"] == null ? null : json["receiveAmt"],
  );

  Map<String, dynamic> toJson() => {
    "fromCountryId": fromCountryId == null ? null : fromCountryId,
    "toCountryId": toCountryId == null ? null : toCountryId,
    "promoCode": promoCode == null ? null : promoCode,
    "transferPurposeId": transferPurposeId == null ? null : transferPurposeId,
    "sendAmt": sendAmt == null ? null : sendAmt,
    "receiveAmt": receiveAmt == null ? null : receiveAmt,
  };
}
