// To parse this JSON data, do
//
//     final relationshipDropdownResponse = relationshipDropdownResponseFromJson(jsonString);

import 'dart:convert';

List<RelationshipDropdownResponse> relationshipDropdownResponseFromJson(String str) => List<RelationshipDropdownResponse>.from(json.decode(str).map((x) => RelationshipDropdownResponse.fromJson(x)));

String relationshipDropdownResponseToJson(List<RelationshipDropdownResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RelationshipDropdownResponse {
  RelationshipDropdownResponse({
    this.activeStatus,
    this.createdBy,
    this.createdDate,
    this.updatedBy,
    this.updatedDate,
    this.relationshipId,
    this.relationshipName,
  });

  int? activeStatus;
  String? createdBy;
  DateTime? createdDate;
  String? updatedBy;
  DateTime? updatedDate;
  int? relationshipId;
  String? relationshipName;

  factory RelationshipDropdownResponse.fromJson(Map<String, dynamic> json) => RelationshipDropdownResponse(
    activeStatus: json["activeStatus"] == null ? null : json["activeStatus"],
    createdBy: json["createdBy"] == null ? null : json["createdBy"],
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
    updatedBy: json["updatedBy"] == null ? null : json["updatedBy"],
    updatedDate: json["updatedDate"] == null ? null : DateTime.parse(json["updatedDate"]),
    relationshipId: json["relationshipId"] == null ? null : json["relationshipId"],
    relationshipName: json["relationshipName"] == null ? null : json["relationshipName"],
  );

  Map<String, dynamic> toJson() => {
    "activeStatus": activeStatus == null ? null : activeStatus,
    "createdBy": createdBy == null ? null : createdBy,
    "createdDate": createdDate == null ? null : createdDate!.toIso8601String(),
    "updatedBy": updatedBy == null ? null : updatedBy,
    "updatedDate": updatedDate == null ? null : updatedDate!.toIso8601String(),
    "relationshipId": relationshipId == null ? null : relationshipId,
    "relationshipName": relationshipName == null ? null : relationshipName,
  };

  @override
  String toString() {
    return '$relationshipName'.toLowerCase();
  }
}

