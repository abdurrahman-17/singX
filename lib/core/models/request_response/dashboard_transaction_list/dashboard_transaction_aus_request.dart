// To parse this JSON data, do
//
//     final dashboardTransactionAustraliaRequest = dashboardTransactionAustraliaRequestFromJson(jsonString);

import 'dart:convert';

DashboardTransactionAustraliaRequest dashboardTransactionAustraliaRequestFromJson(String str) => DashboardTransactionAustraliaRequest.fromJson(json.decode(str));

String dashboardTransactionAustraliaRequestToJson(DashboardTransactionAustraliaRequest data) => json.encode(data.toJson());

class DashboardTransactionAustraliaRequest {
  DashboardTransactionAustraliaRequest({
    this.allstatus,
    this.contactId,
    this.frmdt,
    this.stageId,
    this.todt,
  });

  bool? allstatus;
  int? contactId;
  String? frmdt;
  int? stageId;
  String? todt;

  factory DashboardTransactionAustraliaRequest.fromJson(Map<String, dynamic> json) => DashboardTransactionAustraliaRequest(
    allstatus: json["allstatus"] == null ? null : json["allstatus"],
    contactId: json["contactId"] == null ? null : json["contactId"],
    frmdt: json["frmdt"] == null ? null : json["frmdt"],
    stageId: json["stageId"] == null ? null : json["stageId"],
    todt: json["todt"] == null ? null : json["todt"],
  );

  Map<String, dynamic> toJson() => {
    "allstatus": allstatus == null ? null : allstatus,
    "contactId": contactId == null ? null : contactId,
    "frmdt": frmdt == null ? null : frmdt,
    "stageId": stageId == null ? null : stageId,
    "todt": todt == null ? null : todt,
  };
}
