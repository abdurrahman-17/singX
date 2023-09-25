// To parse this JSON data, do
//
//     final sendCountryResponse = sendCountryResponseFromJson(jsonString);

import 'dart:convert';

List<SendCountryResponse> sendCountryResponseFromJson(String str) => List<SendCountryResponse>.from(json.decode(str).map((x) => SendCountryResponse.fromJson(x)));

String sendCountryResponseToJson(List<SendCountryResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SendCountryResponse {
  SendCountryResponse({
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

  factory SendCountryResponse.fromJson(Map<String, dynamic> json) => SendCountryResponse(
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
