// To parse this JSON data, do
//
//     final getSenderCurrencySingaporeResponse = getSenderCurrencySingaporeResponseFromJson(jsonString);

import 'dart:convert';

List<GetSenderCurrencySingaporeResponse> getSenderCurrencySingaporeResponseFromJson(String str) => List<GetSenderCurrencySingaporeResponse>.from(json.decode(str).map((x) => GetSenderCurrencySingaporeResponse.fromJson(x)));

String getSenderCurrencySingaporeResponseToJson(List<GetSenderCurrencySingaporeResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetSenderCurrencySingaporeResponse {
  GetSenderCurrencySingaporeResponse({
    this.countryId,
    this.isEuroSwift,
    this.isGbpSwift,
    this.countryNameWithCode,
    this.countryName,
    this.currencyCode,
  });

  String? countryId;
  int? isEuroSwift;
  int? isGbpSwift;
  String? countryNameWithCode;
  String? countryName;
  String? currencyCode;

  factory GetSenderCurrencySingaporeResponse.fromJson(Map<String, dynamic> json) => GetSenderCurrencySingaporeResponse(
    countryId: json["countryId"] == null ? null : json["countryId"],
    isEuroSwift: json["isEuroSwift"] == null ? null : json["isEuroSwift"],
    isGbpSwift: json["isGBPSwift"] == null ? null : json["isGBPSwift"],
    countryNameWithCode: json["countryNameWithCode"] == null ? null : json["countryNameWithCode"],
    countryName: json["countryName"] == null ? null : json["countryName"],
    currencyCode: json["currencyCode"] == null ? null : json["currencyCode"],
  );

  Map<String, dynamic> toJson() => {
    "countryId": countryId == null ? null : countryId,
    "isEuroSwift": isEuroSwift == null ? null : isEuroSwift,
    "isGBPSwift": isGbpSwift == null ? null : isGbpSwift,
    "countryNameWithCode": countryNameWithCode == null ? null : countryNameWithCode,
    "countryName": countryName == null ? null : countryName,
    "currencyCode": currencyCode == null ? null : currencyCode,
  };
}
