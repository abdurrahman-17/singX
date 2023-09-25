// To parse this JSON data, do
//
//     final dashboardNotificationResponse = dashboardNotificationResponseFromJson(jsonString);

import 'dart:convert';

List<DashboardNotificationResponse> dashboardNotificationResponseFromJson(String str) => List<DashboardNotificationResponse>.from(json.decode(str).map((x) => DashboardNotificationResponse.fromJson(x)));

String dashboardNotificationResponseToJson(List<DashboardNotificationResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DashboardNotificationResponse {
  DashboardNotificationResponse({
    this.activeStatus,
    this.notificationId,
    this.notificationType,
    this.title,
    this.body,
    this.startDate,
    this.endDate,
  });

  int? activeStatus;
  int? notificationId;
  String? notificationType;
  String? title;
  String? body;
  DateTime? startDate;
  DateTime? endDate;

  factory DashboardNotificationResponse.fromJson(Map<String, dynamic> json) => DashboardNotificationResponse(
    activeStatus: json["activeStatus"] == null ? null : json["activeStatus"],
    notificationId: json["notificationId"] == null ? null : json["notificationId"],
    notificationType: json["notificationType"] == null ? null : json["notificationType"],
    title: json["title"] == null ? null : json["title"],
    body: json["body"] == null ? null : json["body"],
    startDate: json["startDate"] == null ? null : DateTime.parse(json["startDate"]),
    endDate: json["endDate"] == null ? null : DateTime.parse(json["endDate"]),
  );

  Map<String, dynamic> toJson() => {
    "activeStatus": activeStatus == null ? null : activeStatus,
    "notificationId": notificationId == null ? null : notificationId,
    "notificationType": notificationType == null ? null : notificationType,
    "title": title == null ? null : title,
    "body": body == null ? null : body,
    "startDate": startDate == null ? null : "${startDate!.year.toString().padLeft(4, '0')}-${startDate!.month.toString().padLeft(2, '0')}-${startDate!.day.toString().padLeft(2, '0')}",
    "endDate": endDate == null ? null : "${endDate!.year.toString().padLeft(4, '0')}-${endDate!.month.toString().padLeft(2, '0')}-${endDate!.day.toString().padLeft(2, '0')}",
  };
}
