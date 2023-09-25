// To parse this JSON data, do
//
//     final dashboardChinaPayTransferLimitResponse = dashboardChinaPayTransferLimitResponseFromJson(jsonString);

import 'dart:convert';

DashboardChinaPayTransferLimitResponse dashboardChinaPayTransferLimitResponseFromJson(String str) => DashboardChinaPayTransferLimitResponse.fromJson(json.decode(str));

String dashboardChinaPayTransferLimitResponseToJson(DashboardChinaPayTransferLimitResponse data) => json.encode(data.toJson());

class DashboardChinaPayTransferLimitResponse {
  DashboardChinaPayTransferLimitResponse({
    this.message,
    this.status,
  });

  String? message;
  int? status;

  factory DashboardChinaPayTransferLimitResponse.fromJson(Map<String, dynamic> json) => DashboardChinaPayTransferLimitResponse(
    message: json["message"],
    status: json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message,
    "status": status,
  };
}


DashboardPhpTransferLimitResponse dashboardPhpTransferLimitResponseFromJson(String str) => DashboardPhpTransferLimitResponse.fromJson(json.decode(str));

String dashboardPhpTransferLimitResponseToJson(DashboardPhpTransferLimitResponse data) => json.encode(data.toJson());

class DashboardPhpTransferLimitResponse {
  DashboardPhpTransferLimitResponse({
    this.phpCashPickUpLimit,
    this.segmentLimit,
  });

  double? phpCashPickUpLimit;
  int? segmentLimit;

  factory DashboardPhpTransferLimitResponse.fromJson(Map<String, dynamic> json) => DashboardPhpTransferLimitResponse(
    phpCashPickUpLimit: json["phpCashPickUpLimit"],
    segmentLimit: json["segmentLimit"],
  );

  Map<String, dynamic> toJson() => {
    "phpCashPickUpLimit": phpCashPickUpLimit,
    "segmentLimit": segmentLimit,
  };
}