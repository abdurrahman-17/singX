// To parse this JSON data, do
//
//     final initiateTransferEmailResponse = initiateTransferEmailResponseFromJson(jsonString);

import 'dart:convert';

InitiateTransferEmailResponse initiateTransferEmailResponseFromJson(String str) => InitiateTransferEmailResponse.fromJson(json.decode(str));

String initiateTransferEmailResponseToJson(InitiateTransferEmailResponse data) => json.encode(data.toJson());

class InitiateTransferEmailResponse {
  InitiateTransferEmailResponse({
    this.message,
    this.total,
    this.failtokens,
    this.notificationFailed,
    this.notificationSuccess,
    this.status,
  });

  String? message;
  int? total;
  dynamic failtokens;
  int? notificationFailed;
  int? notificationSuccess;
  int? status;

  factory InitiateTransferEmailResponse.fromJson(Map<String, dynamic> json) => InitiateTransferEmailResponse(
    message: json["message"] == null ? null : json["message"],
    total: json["total"] == null ? null : json["total"],
    failtokens: json["failtokens"],
    notificationFailed: json["notificationFailed"] == null ? null : json["notificationFailed"],
    notificationSuccess: json["notificationSuccess"] == null ? null : json["notificationSuccess"],
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "total": total == null ? null : total,
    "failtokens": failtokens,
    "notificationFailed": notificationFailed == null ? null : notificationFailed,
    "notificationSuccess": notificationSuccess == null ? null : notificationSuccess,
    "status": status == null ? null : status,
  };
}
