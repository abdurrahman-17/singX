// To parse this JSON data, do
//
//     final activitiesWalletRequest = activitiesWalletRequestFromJson(jsonString);

import 'dart:convert';

ActivitiesWalletRequest activitiesWalletRequestFromJson(String str) => ActivitiesWalletRequest.fromJson(json.decode(str));

String activitiesWalletRequestToJson(ActivitiesWalletRequest data) => json.encode(data.toJson());

class ActivitiesWalletRequest {
  ActivitiesWalletRequest({
    this.fromDate,
    this.toDate,
    this.transactionId,
    this.status,
  });

  int? fromDate;
  int? toDate;
  String? transactionId;
  String? status;

  factory ActivitiesWalletRequest.fromJson(Map<String, dynamic> json) => ActivitiesWalletRequest(
    fromDate: json["fromDate"] == null ? null : json["fromDate"],
    toDate: json["toDate"] == null ? null : json["toDate"],
    transactionId: json["transactionId"] == null ? null : json["transactionId"],
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "fromDate": fromDate == null ? null : fromDate,
    "toDate": toDate == null ? null : toDate,
    "transactionId": transactionId == null ? null : transactionId,
    "status": status == null ? null : status,
  };
}
