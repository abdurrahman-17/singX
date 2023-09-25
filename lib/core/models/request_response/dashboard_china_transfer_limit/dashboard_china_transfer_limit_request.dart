// To parse this JSON data, do
//
//     final dashboardChinaPayTransferLimitRequest = dashboardChinaPayTransferLimitRequestFromJson(jsonString);

import 'dart:convert';

DashboardChinaPayTransferLimitRequest dashboardChinaPayTransferLimitRequestFromJson(String str) => DashboardChinaPayTransferLimitRequest.fromJson(json.decode(str));

String dashboardChinaPayTransferLimitRequestToJson(DashboardChinaPayTransferLimitRequest data) => json.encode(data.toJson());

class DashboardChinaPayTransferLimitRequest {
  DashboardChinaPayTransferLimitRequest({
    this.contactId,
  });

  int? contactId;

  factory DashboardChinaPayTransferLimitRequest.fromJson(Map<String, dynamic> json) => DashboardChinaPayTransferLimitRequest(
    contactId: json["contactId"],
  );

  Map<String, dynamic> toJson() => {
    "contactId": contactId,
  };
}

DashboardPHPTransferLimitRequest dashboardPHPTransferLimitRequestFromJson(String str) => DashboardPHPTransferLimitRequest.fromJson(json.decode(str));

String dashboardPHPTransferLimitRequestToJson(DashboardChinaPayTransferLimitRequest data) => json.encode(data.toJson());

class DashboardPHPTransferLimitRequest {
  DashboardPHPTransferLimitRequest({
    this.contactId,
  });

  int? contactId;

  factory DashboardPHPTransferLimitRequest.fromJson(Map<String, dynamic> json) => DashboardPHPTransferLimitRequest(
    contactId: json["contactId"],
  );

  Map<String, dynamic> toJson() => {
    "contactId": contactId,
  };
}
