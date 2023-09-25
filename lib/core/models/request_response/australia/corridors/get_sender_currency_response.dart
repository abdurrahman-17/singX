// To parse this JSON data, do
//
//     final getSenderCurrencyAustraliaResponse = getSenderCurrencyAustraliaResponseFromJson(jsonString);

import 'dart:convert';

List<GetSenderCurrencyAustraliaResponse> getSenderCurrencyAustraliaResponseFromJson(String str) => List<GetSenderCurrencyAustraliaResponse>.from(json.decode(str).map((x) => GetSenderCurrencyAustraliaResponse.fromJson(x)));

String getSenderCurrencyAustraliaResponseToJson(List<GetSenderCurrencyAustraliaResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetSenderCurrencyAustraliaResponse {
  GetSenderCurrencyAustraliaResponse({
    this.countryId,
    this.country,
    this.currencyCode,
    this.currencyName,
  });

  int? countryId;
  String? country;
  String? currencyCode;
  String? currencyName;

  factory GetSenderCurrencyAustraliaResponse.fromJson(Map<String, dynamic> json) => GetSenderCurrencyAustraliaResponse(
    countryId: json["countryId"] == null ? null : json["countryId"],
    country: json["country"] == null ? null : json["country"],
    currencyCode: json["currencyCode"] == null ? null : json["currencyCode"],
    currencyName: json["currencyName"] == null ? null : json["currencyName"],
  );

  Map<String, dynamic> toJson() => {
    "countryId": countryId == null ? null : countryId,
    "country": country == null ? null : country,
    "currencyCode": currencyCode == null ? null : currencyCode,
    "currencyName": currencyName == null ? null : currencyName,
  };
}
