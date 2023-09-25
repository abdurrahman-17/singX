// To parse this JSON data, do
//
//     final ifscDetailsResponse = ifscDetailsResponseFromJson(jsonString);

import 'dart:convert';

IfscDetailsResponse ifscDetailsResponseFromJson(String str) => IfscDetailsResponse.fromJson(json.decode(str));

String ifscDetailsResponseToJson(IfscDetailsResponse data) => json.encode(data.toJson());


class IfscDetailsResponse {
  IfscDetailsResponse({
    this.message,
    this.status,
    this.branchId,
    this.activeStatus,
    this.branchAddress,
    this.branchcode,
    this.branchName,
    this.bsbOrAbaCode,
    this.cityId,
    this.countryId,
    this.createdBy,
    this.createdDate,
    this.financialinstituteNo,
    this.ibanNumber,
    this.ifscCode,
    this.sortCode,
    this.stateId,
    this.swiftCode,
    this.updatedBy,
    this.updatedDate,
    this.versionId,
    this.bankId,
    this.cityName,
    this.stateName,
    this.bankName,
  });

  String? message;
  int? status;
  int? branchId;
  int? activeStatus;
  String? branchAddress;
  dynamic branchcode;
  String? branchName;
  dynamic bsbOrAbaCode;
  int? cityId;
  int? countryId;
  String? createdBy;
  String? createdDate;
  dynamic financialinstituteNo;
  dynamic ibanNumber;
  String? ifscCode;
  dynamic sortCode;
  int? stateId;
  dynamic swiftCode;
  dynamic updatedBy;
  dynamic updatedDate;
  int? versionId;
  int? bankId;
  String? cityName;
  String? stateName;
  dynamic bankName;

  factory IfscDetailsResponse.fromJson(Map<String, dynamic> json) => IfscDetailsResponse(
    message: json["message"] == null ? null : json["message"],
    status: json["status"] == null ? null : json["status"],
    branchId: json["branchId"] == null ? null : json["branchId"],
    activeStatus: json["activeStatus"] == null ? null : json["activeStatus"],
    branchAddress: json["branchAddress"] == null ? null : json["branchAddress"],
    branchcode: json["branchcode"],
    branchName: json["branchName"] == null ? null : json["branchName"],
    bsbOrAbaCode: json["bsbOrABACode"],
    cityId: json["cityId"] == null ? null : json["cityId"],
    countryId: json["countryId"] == null ? null : json["countryId"],
    createdBy: json["createdBy"] == null ? null : json["createdBy"],
    createdDate: json["createdDate"] == null ? null : json["createdDate"],
    financialinstituteNo: json["financialinstituteNo"],
    ibanNumber: json["ibanNumber"],
    ifscCode: json["ifscCode"] == null ? null : json["ifscCode"],
    sortCode: json["sortCode"],
    stateId: json["stateId"] == null ? null : json["stateId"],
    swiftCode: json["swiftCode"],
    updatedBy: json["updatedBy"],
    updatedDate: json["updatedDate"],
    versionId: json["versionId"] == null ? null : json["versionId"],
    bankId: json["bankId"] == null ? null : json["bankId"],
    cityName: json["cityName"] == null ? null : json["cityName"],
    stateName: json["stateName"] == null ? null : json["stateName"],
    bankName: json["bankName"],
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "status": status == null ? null : status,
    "branchId": branchId == null ? null : branchId,
    "activeStatus": activeStatus == null ? null : activeStatus,
    "branchAddress": branchAddress == null ? null : branchAddress,
    "branchcode": branchcode,
    "branchName": branchName == null ? null : branchName,
    "bsbOrABACode": bsbOrAbaCode,
    "cityId": cityId == null ? null : cityId,
    "countryId": countryId == null ? null : countryId,
    "createdBy": createdBy == null ? null : createdBy,
    "createdDate": createdDate == null ? null : createdDate,
    "financialinstituteNo": financialinstituteNo,
    "ibanNumber": ibanNumber,
    "ifscCode": ifscCode == null ? null : ifscCode,
    "sortCode": sortCode,
    "stateId": stateId == null ? null : stateId,
    "swiftCode": swiftCode,
    "updatedBy": updatedBy,
    "updatedDate": updatedDate,
    "versionId": versionId == null ? null : versionId,
    "bankId": bankId == null ? null : bankId,
    "cityName": cityName == null ? null : cityName,
    "stateName": stateName == null ? null : stateName,
    "bankName": bankName,
  };
}
