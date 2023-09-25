// To parse this JSON data, do
//
//     final stateListResponse = stateListResponseFromJson(jsonString);

import 'dart:convert';

List<StateListResponse> stateListResponseFromJson(String str) => List<StateListResponse>.from(json.decode(str).map((x) => StateListResponse.fromJson(x)));

String stateListResponseToJson(List<StateListResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class StateListResponse {
  StateListResponse({
    this.stateId,
    this.activeStatus,
    this.countryId,
    this.createdBy,
    this.createdDate,
    this.stateCapital,
    this.stateCode,
    this.stateCodeChar2,
    this.stateCodeChar3,
    this.stateDescription,
    this.stateFlag,
    this.stateName,
    this.updatedBy,
    this.updatedDate,
  });

  int? stateId;
  int? activeStatus;
  int? countryId;
  String? createdBy;
  String? createdDate;
  dynamic stateCapital;
  dynamic stateCode;
  String? stateCodeChar2;
  dynamic stateCodeChar3;
  dynamic stateDescription;
  dynamic stateFlag;
  String? stateName;
  dynamic updatedBy;
  dynamic updatedDate;

  factory StateListResponse.fromJson(Map<String, dynamic> json) => StateListResponse(
    stateId: json["stateId"] == null ? null : json["stateId"],
    activeStatus: json["activeStatus"] == null ? null : json["activeStatus"],
    countryId: json["countryId"] == null ? null : json["countryId"],
    createdBy: json["createdBy"] == null ? null : json["createdBy"],
    createdDate: json["createdDate"] == null ? null : json["createdDate"],
    stateCapital: json["stateCapital"],
    stateCode: json["stateCode"],
    stateCodeChar2: json["stateCodeChar2"] == null ? null : json["stateCodeChar2"],
    stateCodeChar3: json["stateCodeChar3"],
    stateDescription: json["stateDescription"],
    stateFlag: json["stateFlag"],
    stateName: json["stateName"] == null ? null : json["stateName"],
    updatedBy: json["updatedBy"],
    updatedDate: json["updatedDate"],
  );

  Map<String, dynamic> toJson() => {
    "stateId": stateId == null ? null : stateId,
    "activeStatus": activeStatus == null ? null : activeStatus,
    "countryId": countryId == null ? null : countryId,
    "createdBy": createdBy == null ? null : createdBy,
    "createdDate": createdDate == null ? null : createdDate,
    "stateCapital": stateCapital,
    "stateCode": stateCode,
    "stateCodeChar2": stateCodeChar2 == null ? null : stateCodeChar2,
    "stateCodeChar3": stateCodeChar3,
    "stateDescription": stateDescription,
    "stateFlag": stateFlag,
    "stateName": stateName == null ? null : stateName,
    "updatedBy": updatedBy,
    "updatedDate": updatedDate,
  };
}


