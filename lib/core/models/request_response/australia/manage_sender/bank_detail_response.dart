// To parse this JSON data, do
//
//     final BankDetailResponse = BankDetailResponseFromJson(jsonString);

import 'dart:convert';
List<BankDetailResponse> BankDetailResponseFromJson(String? str) => List<BankDetailResponse>.from(json.decode(str!).map((x) => BankDetailResponse.fromJson(x)));

String? BankDetailResponseToJson(List<BankDetailResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class BankDetailResponse {
  BankDetailResponse({
    this.bankId,
    this.activeStatus,
    this.bankCode,
    this.bankName,
    this.bankTypeId,
    this.createdBy,
    this.createdDate,
    this.issuerCode,
    this.maximumAccountNo,
    this.minimumAccountNo,
    this.countryId,
    this.updatedBy,
    this.updatedDate,
    this.versionId,
    this.wireTransferModeId,
  });

  int? bankId;
  int? activeStatus;
  String? bankCode;
  String? bankName;
  int? bankTypeId;
  String? createdBy;
  String? createdDate;
  dynamic issuerCode;
  int? maximumAccountNo;
  int? minimumAccountNo;
  int? countryId;
  dynamic updatedBy;
  String? updatedDate;
  int? versionId;
  int? wireTransferModeId;

  factory BankDetailResponse.fromJson(Map<String?, dynamic> json) => BankDetailResponse(
    bankId: json["bankId"] == null ? null : json["bankId"],
    activeStatus: json["activeStatus"] == null ? null : json["activeStatus"],
    bankCode: json["bankCode"] == null ? null : json["bankCode"],
    bankName: json["bankName"] == null ? null : json["bankName"],
    bankTypeId: json["bankTypeId"] == null ? null : json["bankTypeId"],
    createdBy: json["createdBy"] == null ? null : json["createdBy"],
    createdDate: json["createdDate"] == null ? null : json["createdDate"],
    issuerCode: json["issuerCode"],
    maximumAccountNo: json["maximumAccountNo"] == null ? null : json["maximumAccountNo"],
    minimumAccountNo: json["minimumAccountNo"] == null ? null : json["minimumAccountNo"],
    countryId: json["countryId"] == null ? null : json["countryId"],
    updatedBy: json["updatedBy"],
    updatedDate: json["updatedDate"] == null ? null : json["updatedDate"],
    versionId: json["versionId"] == null ? null : json["versionId"],
    wireTransferModeId: json["wireTransferModeId"] == null ? null : json["wireTransferModeId"],
  );

  Map<String?, dynamic> toJson() => {
    "bankId": bankId == null ? null : bankId,
    "activeStatus": activeStatus == null ? null : activeStatus,
    "bankCode": bankCode == null ? null : bankCode,
    "bankName": bankName == null ? null : bankName,
    "bankTypeId": bankTypeId == null ? null : bankTypeId,
    "createdBy": createdBy == null ? null : createdBy,
    "createdDate": createdDate == null ? null : createdDate,
    "issuerCode": issuerCode,
    "maximumAccountNo": maximumAccountNo == null ? null : maximumAccountNo,
    "minimumAccountNo": minimumAccountNo == null ? null : minimumAccountNo,
    "countryId": countryId == null ? null : countryId,
    "updatedBy": updatedBy,
    "updatedDate": updatedDate == null ? null : updatedDate,
    "versionId": versionId == null ? null : versionId,
    "wireTransferModeId": wireTransferModeId == null ? null : wireTransferModeId,
  };

  @override
  String toString() {
    return '$bankName'.toLowerCase();
  }
}
