// To parse this JSON data, do
//
//     final receiveCountryResponse = receiveCountryResponseFromJson(jsonString);

import 'dart:convert';

List<ReceiveCountryResponse> receiveCountryResponseFromJson(String str) => List<ReceiveCountryResponse>.from(json.decode(str).map((x) => ReceiveCountryResponse.fromJson(x)));

String receiveCountryResponseToJson(List<ReceiveCountryResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReceiveCountryResponse {
  ReceiveCountryResponse({
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

  factory ReceiveCountryResponse.fromJson(Map<String, dynamic> json) => ReceiveCountryResponse(
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
