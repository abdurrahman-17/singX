// To parse this JSON data, do
//
//     final pricingResponse = pricingResponseFromJson(jsonString);

import 'dart:convert';

PricingResponse pricingResponseFromJson(String str) => PricingResponse.fromJson(json.decode(str));

String pricingResponseToJson(PricingResponse data) => json.encode(data.toJson());

class PricingResponse {
  PricingResponse({
    this.billForBankTransfer,
    this.corridorId,
    this.billWithoutFee,
    this.billForCreditCard,
    this.billForWallet,
  });

  String? billForBankTransfer;
  String? corridorId;
  String? billWithoutFee;
  String? billForCreditCard;
  String? billForWallet;

  factory PricingResponse.fromJson(Map<String, dynamic> json) => PricingResponse(
    billForBankTransfer: json["Bill For Bank Transfer"] == null ? null : json["Bill For Bank Transfer"],
    corridorId: json["CorridorId"] == null ? null : json["CorridorId"],
    billWithoutFee: json["Bill without fee"] == null ? null : json["Bill without fee"],
    billForCreditCard: json["Bill For Credit Card"] == null ? null : json["Bill For Credit Card"],
    billForWallet: json["Bill For Wallet"] == null ? null : json["Bill For Wallet"],
  );

  Map<String, dynamic> toJson() => {
    "Bill For Bank Transfer": billForBankTransfer == null ? null : billForBankTransfer,
    "CorridorId": corridorId == null ? null : corridorId,
    "Bill without fee": billWithoutFee == null ? null : billWithoutFee,
    "Bill For Credit Card": billForCreditCard == null ? null : billForCreditCard,
    "Bill For Wallet": billForWallet == null ? null : billForWallet,
  };
}
