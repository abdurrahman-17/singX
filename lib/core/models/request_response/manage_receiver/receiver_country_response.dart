// To parse this JSON data, do
//
//     final ReceiverCountryResponse = ReceiverCountryResponseFromJson(jsonString);

import 'dart:convert';

Map<String, List<ReceiverCountryResponse>> ReceiverCountryResponseFromJson(String str) => Map.from(json.decode(str)).map((k, v) => MapEntry<String, List<ReceiverCountryResponse>>(k, List<ReceiverCountryResponse>.from(v.map((x) => ReceiverCountryResponse.fromJson(x)))));

String ReceiverCountryResponseToJson(Map<String, List<ReceiverCountryResponse>> data) => json.encode(Map.from(data).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson())))));

class ReceiverCountryResponse {
  ReceiverCountryResponse({
    this.country,
    this.swift,
  });

  String? country;
  bool? swift;

  factory ReceiverCountryResponse.fromJson(Map<String, dynamic> json) => ReceiverCountryResponse(
    country: json["country"] == null ? null : json["country"],
    swift: json["swift"] == null ? null : json["swift"],
  );

  Map<String, dynamic> toJson() => {
    "country": country == null ? null : country,
    "swift": swift == null ? null : swift,
  };
}
