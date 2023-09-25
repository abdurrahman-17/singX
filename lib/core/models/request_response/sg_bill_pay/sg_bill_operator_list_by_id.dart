// To parse this JSON data, do
//
//     final operatorById = operatorByIdFromJson(jsonString);

import 'dart:convert';

OperatorById operatorByIdFromJson(String str) => OperatorById.fromJson(json.decode(str));

String operatorByIdToJson(OperatorById data) => json.encode(data.toJson());

class OperatorById {
  OperatorById({
    this.operatorId,
    this.activeStatusAu,
    this.activeStatusHk,
    this.activeStatusSg,
    this.ad1,
    this.ad2,
    this.ad3,
    this.bbpsEnabled,
    this.category,
    this.circleId,
    this.cn,
    this.countryId,
    this.operatorName,
    this.regex,
    this.viewBill,
  });

  int? operatorId;
  int? activeStatusAu;
  int? activeStatusHk;
  int? activeStatusSg;
  String? ad1;
  String? ad2;
  String? ad3;
  String? bbpsEnabled;
  String? category;
  int? circleId;
  String? cn;
  int? countryId;
  String? operatorName;
  String? regex;
  String? viewBill;

  factory OperatorById.fromJson(Map<String, dynamic> json) => OperatorById(
    operatorId: json["operatorId"] == null ? null : json["operatorId"],
    activeStatusAu: json["activeStatusAU"] == null ? null : json["activeStatusAU"],
    activeStatusHk: json["activeStatusHK"] == null ? null : json["activeStatusHK"],
    activeStatusSg: json["activeStatusSG"] == null ? null : json["activeStatusSG"],
    ad1: json["ad1"] == null ? null : json["ad1"],
    ad2: json["ad2"] == null ? null : json["ad2"],
    ad3: json["ad3"] == null ? null : json["ad3"],
    bbpsEnabled: json["bbps_Enabled"] == null ? null : json["bbps_Enabled"],
    category: json["category"] == null ? null : json["category"],
    circleId: json["circleId"] == null ? null : json["circleId"],
    cn: json["cn"] == null ? null : json["cn"],
    countryId: json["countryId"] == null ? null : json["countryId"],
    operatorName: json["operatorName"] == null ? null : json["operatorName"],
    regex: json["regex"] == null ? null : json["regex"],
    viewBill: json["viewBill"] == null ? null : json["viewBill"],
  );

  Map<String, dynamic> toJson() => {
    "operatorId": operatorId == null ? null : operatorId,
    "activeStatusAU": activeStatusAu == null ? null : activeStatusAu,
    "activeStatusHK": activeStatusHk == null ? null : activeStatusHk,
    "activeStatusSG": activeStatusSg == null ? null : activeStatusSg,
    "ad1": ad1 == null ? null : ad1,
    "ad2": ad2 == null ? null : ad2,
    "ad3": ad3 == null ? null : ad3,
    "bbps_Enabled": bbpsEnabled == null ? null : bbpsEnabled,
    "category": category == null ? null : category,
    "circleId": circleId == null ? null : circleId,
    "cn": cn == null ? null : cn,
    "countryId": countryId == null ? null : countryId,
    "operatorName": operatorName == null ? null : operatorName,
    "regex": regex == null ? null : regex,
    "viewBill": viewBill == null ? null : viewBill,
  };
}
