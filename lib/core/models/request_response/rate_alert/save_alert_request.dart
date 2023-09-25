// To parse this JSON data, do
//
//     final saveAlertRequest = saveAlertRequestFromJson(jsonString);

import 'dart:convert';

SaveAlertRequest saveAlertRequestFromJson(String str) => SaveAlertRequest.fromJson(json.decode(str));

String saveAlertRequestToJson(SaveAlertRequest data) => json.encode(data.toJson());

class SaveAlertRequest {
  SaveAlertRequest({
    this.corridor,
    this.alertType,
    this.alertRate,
    this.alertMode,
  });

  String? corridor;
  String? alertType;
  int? alertRate;
  String? alertMode;

  factory SaveAlertRequest.fromJson(Map<String, dynamic> json) => SaveAlertRequest(
    corridor: json["corridor"] == null ? null : json["corridor"],
    alertType: json["alertType"] == null ? null : json["alertType"],
    alertRate: json["alertRate"] == null ? null : json["alertRate"],
    alertMode: json["alertMode"] == null ? null : json["alertMode"],
  );

  Map<String, dynamic> toJson() => {
    "corridor": corridor == null ? null : corridor,
    "alertType": alertType == null ? null : alertType,
    "alertRate": alertRate == null ? null : alertRate,
    "alertMode": alertMode == null ? null : alertMode,
  };
}
