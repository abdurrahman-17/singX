// To parse this JSON data, do
//
//     final relationShipAustraliaResponse = relationShipAustraliaResponseFromJson(jsonString);

import 'dart:convert';

List<RelationShipAustraliaResponse> relationShipAustraliaResponseFromJson(String str) => List<RelationShipAustraliaResponse>.from(json.decode(str).map((x) => RelationShipAustraliaResponse.fromJson(x)));

String relationShipAustraliaResponseToJson(List<RelationShipAustraliaResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RelationShipAustraliaResponse {
  RelationShipAustraliaResponse({
    this.relationshipId,
    this.activeStatus,
    this.createdBy,
    this.createdDate,
    this.mtradeCode,
    this.relationshipName,
    this.relationshipType,
    this.trangloCode,
    this.updatedBy,
    this.updatedDate,
    this.versionId,
  });

  int? relationshipId;
  int? activeStatus;
  String? createdBy;
  DateTime? createdDate;
  int? mtradeCode;
  String? relationshipName;
  int? relationshipType;
  int? trangloCode;
  dynamic updatedBy;
  dynamic updatedDate;
  int? versionId;

  factory RelationShipAustraliaResponse.fromJson(Map<String, dynamic> json) => RelationShipAustraliaResponse(
    relationshipId: json["relationshipId"] == null ? null : json["relationshipId"],
    activeStatus: json["activeStatus"] == null ? null : json["activeStatus"],
    createdBy: json["createdBy"] == null ? null : json["createdBy"],
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
    mtradeCode: json["mtradeCode"] == null ? null : json["mtradeCode"],
    relationshipName: json["relationshipName"] == null ? null : json["relationshipName"],
    relationshipType: json["relationshipType"] == null ? null : json["relationshipType"],
    trangloCode: json["trangloCode"] == null ? null : json["trangloCode"],
    updatedBy: json["updatedBy"],
    updatedDate: json["updatedDate"],
    versionId: json["versionId"] == null ? null : json["versionId"],
  );

  Map<String, dynamic> toJson() => {
    "relationshipId": relationshipId == null ? null : relationshipId,
    "activeStatus": activeStatus == null ? null : activeStatus,
    "createdBy": createdBy == null ? null : createdBy,
    "createdDate": createdDate == null ? null : "${createdDate!.year.toString().padLeft(4, '0')}-${createdDate!.month.toString().padLeft(2, '0')}-${createdDate!.day.toString().padLeft(2, '0')}",
    "mtradeCode": mtradeCode == null ? null : mtradeCode,
    "relationshipName": relationshipName == null ? null : relationshipName,
    "relationshipType": relationshipType == null ? null : relationshipType,
    "trangloCode": trangloCode == null ? null : trangloCode,
    "updatedBy": updatedBy,
    "updatedDate": updatedDate,
    "versionId": versionId == null ? null : versionId,
  };
}
