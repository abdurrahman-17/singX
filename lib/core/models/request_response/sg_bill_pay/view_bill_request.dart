// To parse this JSON data, do
//
//     final viewBillRequest = viewBillRequestFromJson(jsonString);

import 'dart:convert';

ViewBillRequest viewBillRequestFromJson(String str) => ViewBillRequest.fromJson(json.decode(str));

String viewBillRequestToJson(ViewBillRequest data) => json.encode(data.toJson());

class ViewBillRequest {
  ViewBillRequest({
    this.consumerNo,
    this.adParam1,
    this.adParam2,
    this.adParam3,
    this.circleId,
    this.operatorId,
  });

  String? consumerNo;
  String? adParam1;
  String? adParam2;
  String? adParam3;
  int? circleId;
  int? operatorId;

  factory ViewBillRequest.fromJson(Map<String, dynamic> json) => ViewBillRequest(
    consumerNo: json["consumerNo"] == null ? null : json["consumerNo"],
    adParam1: json["adParam1"] == null ? null : json["adParam1"],
    adParam2: json["adParam2"] == null ? null : json["adParam2"],
    adParam3: json["adParam3"] == null ? null : json["adParam3"],
    circleId: json["circleId"] == null ? null : json["circleId"],
    operatorId: json["operatorId"] == null ? null : json["operatorId"],
  );

  Map<String, dynamic> toJson() => {
    "consumerNo": consumerNo == null ? null : consumerNo,
    "adParam1": adParam1 == null ? null : adParam1,
    "adParam2": adParam2 == null ? null : adParam2,
    "adParam3": adParam3 == null ? null : adParam3,
    "circleId": circleId == null ? null : circleId,
    "operatorId": operatorId == null ? null : operatorId,
  };
}
