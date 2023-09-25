// To parse this JSON data, do
//
//     final updateAlertRequest = updateAlertRequestFromJson(jsonString);

import 'dart:convert';

UpdateAlertRequest updateAlertRequestFromJson(String str) => UpdateAlertRequest.fromJson(json.decode(str));

String updateAlertRequestToJson(UpdateAlertRequest data) => json.encode(data.toJson());

class UpdateAlertRequest {
  UpdateAlertRequest({
    this.subscribeId,
    this.alertType,
    this.alertRate,
    this.alertMode,
  });

  String? subscribeId;
  String? alertType;
  var alertRate;
  String? alertMode;

  factory UpdateAlertRequest.fromJson(Map<String, dynamic> json) => UpdateAlertRequest(
    subscribeId: json["subscribeId"] == null ? null : json["subscribeId"],
    alertType: json["alertType"] == null ? null : json["alertType"],
    alertRate: json["alertRate"] == null ? null : json["alertRate"],
    alertMode: json["alertMode"] == null ? null : json["alertMode"],
  );

  Map<String, dynamic> toJson() => {
    "subscribeId": subscribeId == null ? null : subscribeId,
    "alertType": alertType == null ? null : alertType,
    "alertRate": alertRate == null ? null : alertRate,
    "alertMode": alertMode == null ? null : alertMode,
  };
}
