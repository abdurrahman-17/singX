// To parse this JSON data, do
//
//     final alertListResponse = alertListResponseFromJson(jsonString);

import 'dart:convert';

List<AlertListResponse> alertListResponseFromJson(String str) => List<AlertListResponse>.from(json.decode(str).map((x) => AlertListResponse.fromJson(x)));
//
// String alertListResponseToJson(List<AlertListResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class AlertListResponse {
  AlertListResponse({
    this.corridor,
    this.alertTypeString,
    this.alertModeString,
    this.subscribeId,
    this.phoneCountryCode,
    this.phoneNumber,
    this.alertType,
    this.alertMode,
    this.currencyRate,
  });

  Corridor? corridor;
  String? alertTypeString;
  String? alertModeString;
  String? subscribeId;
  String? phoneCountryCode;
  String? phoneNumber;
  int? alertType;
  int? alertMode;
  double? currencyRate;

  factory AlertListResponse.fromJson(Map<String, dynamic> json) => AlertListResponse(
    corridor: json["corridor"] == null ? null : Corridor.fromJson(json["corridor"]),
    alertTypeString: json["alertTypeString"] == null ? null : json["alertTypeString"],
    alertModeString: json["alertModeString"] == null ? null : json["alertModeString"],
    subscribeId: json["subscribeId"] == null ? null : json["subscribeId"],
    phoneCountryCode: json["phoneCountryCode"] == null ? null : json["phoneCountryCode"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    alertType: json["alertType"] == null ? null : json["alertType"],
    alertMode: json["alertMode"] == null ? null : json["alertMode"],
    currencyRate: json["currencyRate"] == null ? null : json["currencyRate"],
  );

  Map<String, dynamic> toJson() => {
    "corridor": corridor == null ? null : corridor!.toJson(),
    "alertTypeString": alertTypeString == null ? null : alertTypeString,
    "alertModeString": alertModeString == null ? null : alertModeString,
    "subscribeId": subscribeId == null ? null : subscribeId,
    "phoneCountryCode": phoneCountryCode == null ? null : phoneCountryCode,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "alertType": alertType == null ? null : alertType,
    "alertMode": alertMode == null ? null : alertMode,
    "currencyRate": currencyRate == null ? null : currencyRate,
  };
}

class Corridor {
  Corridor({
    this.corridorName,
    this.corridorId,
    this.countryId,
    this.toCountryId,
  });

  String? corridorName;
  String? corridorId;
  String? countryId;
  String? toCountryId;

  factory Corridor.fromJson(Map<String, dynamic> json) => Corridor(
    corridorName: json["corridorName"] == null ? null : json["corridorName"],
    corridorId: json["corridorId"] == null ? null : json["corridorId"],
    countryId: json["countryId"] == null ? null : json["countryId"],
    toCountryId: json["toCountryId"] == null ? null : json["toCountryId"],
  );

  Map<String, dynamic> toJson() => {
    "corridorName": corridorName == null ? null : corridorName,
    "corridorId": corridorId == null ? null : corridorId,
    "countryId": countryId == null ? null : countryId,
    "toCountryId": toCountryId == null ? null : toCountryId,
  };
}
