// To parse this JSON data, do
//
//     final getReceiverCurrencyAustraliaResponse = getReceiverCurrencyAustraliaResponseFromJson(jsonString);

import 'dart:convert';

List<GetReceiverCurrencyAustraliaResponse> getReceiverCurrencyAustraliaResponseFromJson(String str) => List<GetReceiverCurrencyAustraliaResponse>.from(json.decode(str).map((x) => GetReceiverCurrencyAustraliaResponse.fromJson(x)));

String getReceiverCurrencyAustraliaResponseToJson(List<GetReceiverCurrencyAustraliaResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetReceiverCurrencyAustraliaResponse {
  GetReceiverCurrencyAustraliaResponse({
    this.countryId,
    this.country,
    this.currencyCode,
    this.currencyName,
  });

  int? countryId;
  String? country;
  String? currencyCode;
  String? currencyName;

  factory GetReceiverCurrencyAustraliaResponse.fromJson(Map<String, dynamic> json) => GetReceiverCurrencyAustraliaResponse(
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
