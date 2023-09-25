// To parse this JSON data, do
//
//     final countryList = countryListFromJson(jsonString);

import 'dart:convert';

List<CountryList> countryListFromJson(String str) => List<CountryList>.from(json.decode(str).map((x) => CountryList.fromJson(x)));

String countryListToJson(List<CountryList> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CountryList {
  CountryList({
    this.countryId,
    this.countryCode,
    this.countryName,
    this.currencyCode,
    this.phoneCountryCode,
  });

  String? countryId;
  String? countryCode;
  String? countryName;
  String? currencyCode;
  String? phoneCountryCode;

  factory CountryList.fromJson(Map<String, dynamic> json) => CountryList(
    countryId: json["countryId"] == null ? null : json["countryId"],
    countryCode: json["countryCode"] == null ? null : json["countryCode"],
    countryName: json["countryName"] == null ? null : json["countryName"],
    currencyCode: json["currencyCode"] == null ? null : json["currencyCode"],
    phoneCountryCode: json["phoneCountryCode"] == null ? null : json["phoneCountryCode"],
  );

  Map<String, dynamic> toJson() => {
    "countryId": countryId == null ? null : countryId,
    "countryCode": countryCode == null ? null : countryCode,
    "countryName": countryName == null ? null : countryName,
    "currencyCode": currencyCode == null ? null : currencyCode,
    "phoneCountryCode": phoneCountryCode == null ? null : phoneCountryCode,
  };
}
