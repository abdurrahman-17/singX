// To parse this JSON data, do
//
//     final pricingRequest = pricingRequestFromJson(jsonString);

import 'dart:convert';

PricingRequest pricingRequestFromJson(String str) => PricingRequest.fromJson(json.decode(str));

String pricingRequestToJson(PricingRequest data) => json.encode(data.toJson());

class PricingRequest {
  PricingRequest({
    this.billAmnt,
    this.sourceCountry,
    this.receiveCountry,
    this.customerType,
  });

  String? billAmnt;
  String? sourceCountry;
  String? receiveCountry;
  String? customerType;

  factory PricingRequest.fromJson(Map<String, dynamic> json) => PricingRequest(
    billAmnt: json["billAmnt"] == null ? null : json["billAmnt"],
    sourceCountry: json["sourceCountry"] == null ? null : json["sourceCountry"],
    receiveCountry: json["receiveCountry"] == null ? null : json["receiveCountry"],
    customerType: json["customerType"] == null ? null : json["customerType"],
  );

  Map<String, dynamic> toJson() => {
    "billAmnt": billAmnt == null ? null : billAmnt,
    "sourceCountry": sourceCountry == null ? null : sourceCountry,
    "receiveCountry": receiveCountry == null ? null : receiveCountry,
    "customerType": customerType == null ? null : customerType,
  };
}
