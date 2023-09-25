// To parse this JSON data, do
//
//     final authDetailResponse = authDetailResponseFromJson(jsonString);

import 'dart:convert';

AuthDetailResponse authDetailResponseFromJson(String str) => AuthDetailResponse.fromJson(json.decode(str));

String authDetailResponseToJson(AuthDetailResponse data) => json.encode(data.toJson());

class AuthDetailResponse {
  AuthDetailResponse({
    this.customerTypeName,
    this.loginId,
    this.contactId,
    this.customerId,
    this.profileStatus,
    this.userId,
    this.status,
  });

  String? customerTypeName;
  String? loginId;
  String? contactId;
  String? customerId;
  int? profileStatus;
  String? userId;
  String? status;

  factory AuthDetailResponse.fromJson(Map<String, dynamic> json) => AuthDetailResponse(
    customerTypeName: json["customerTypeName"] == null ? null : json["customerTypeName"],
    loginId: json["loginId"] == null ? null : json["loginId"],
    contactId: json["contactId"] == null ? null : json["contactId"],
    customerId: json["customerId"] == null ? null : json["customerId"],
    profileStatus: json["profileStatus"] == null ? null : json["profileStatus"],
    userId: json["userId"] == null ? null : json["userId"],
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "customerTypeName": customerTypeName == null ? null : customerTypeName,
    "loginId": loginId == null ? null : loginId,
    "contactId": contactId == null ? null : contactId,
    "customerId": customerId == null ? null : customerId,
    "profileStatus": profileStatus == null ? null : profileStatus,
    "userId": userId == null ? null : userId,
    "status": status == null ? null : status,
  };
}
