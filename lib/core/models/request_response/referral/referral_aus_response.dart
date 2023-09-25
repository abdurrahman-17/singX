// To parse this JSON data, do
//
//     final referralAusResponse = referralAusResponseFromJson(jsonString);

import 'dart:convert';

ReferralAusResponse referralAusResponseFromJson(String str) => ReferralAusResponse.fromJson(json.decode(str));

String referralAusResponseToJson(ReferralAusResponse data) => json.encode(data.toJson());

class ReferralAusResponse {
  ReferralAusResponse({
    this.referralId,
    this.activeStatus,
    this.contactId,
    this.createdDate,
    this.referralCode,
  });

  int? referralId;
  int? activeStatus;
  int? contactId;
  String? createdDate;
  String? referralCode;

  factory ReferralAusResponse.fromJson(Map<String, dynamic> json) => ReferralAusResponse(
    referralId: json["referralId"] == null ? null : json["referralId"],
    activeStatus: json["activeStatus"] == null ? null : json["activeStatus"],
    contactId: json["contactId"] == null ? null : json["contactId"],
    createdDate: json["createdDate"] == null ? null : json["createdDate"],
    referralCode: json["referralCode"] == null ? null : json["referralCode"],
  );

  Map<String, dynamic> toJson() => {
    "referralId": referralId == null ? null : referralId,
    "activeStatus": activeStatus == null ? null : activeStatus,
    "contactId": contactId == null ? null : contactId,
    "createdDate": createdDate == null ? null : createdDate,
    "referralCode": referralCode == null ? null : referralCode,
  };
}
