// To parse this JSON data, do
//
//     final transferPurposeAustraliaResponse = transferPurposeAustraliaResponseFromJson(jsonString);

import 'dart:convert';

List<TransferPurposeAustraliaResponse> transferPurposeAustraliaResponseFromJson(String str) => List<TransferPurposeAustraliaResponse>.from(json.decode(str).map((x) => TransferPurposeAustraliaResponse.fromJson(x)));

String transferPurposeAustraliaResponseToJson(List<TransferPurposeAustraliaResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TransferPurposeAustraliaResponse {
  TransferPurposeAustraliaResponse({
    this.transferPurposeId,
    this.activeStatus,
    this.createdBy,
    this.createdDate,
    this.federalPurposeCode,
    this.trangloPurposeCode,
    this.transferPurposeName,
    this.updatedBy,
    this.updatedDate,
    this.versionId,
  });

  int? transferPurposeId;
  int? activeStatus;
  String? createdBy;
  DateTime? createdDate;
  String? federalPurposeCode;
  int? trangloPurposeCode;
  String? transferPurposeName;
  dynamic updatedBy;
  dynamic updatedDate;
  int? versionId;

  factory TransferPurposeAustraliaResponse.fromJson(Map<String, dynamic> json) => TransferPurposeAustraliaResponse(
    transferPurposeId: json["transferPurposeId"] == null ? null : json["transferPurposeId"],
    activeStatus: json["activeStatus"] == null ? null : json["activeStatus"],
    createdBy: json["createdBy"] == null ? null : json["createdBy"],
    createdDate: json["createdDate"] == null ? null : DateTime.parse(json["createdDate"]),
    federalPurposeCode: json["federalPurposeCode"] == null ? null : json["federalPurposeCode"],
    trangloPurposeCode: json["trangloPurposeCode"] == null ? null : json["trangloPurposeCode"],
    transferPurposeName: json["transferPurposeName"] == null ? null : json["transferPurposeName"],
    updatedBy: json["updatedBy"],
    updatedDate: json["updatedDate"],
    versionId: json["versionId"] == null ? null : json["versionId"],
  );

  Map<String, dynamic> toJson() => {
    "transferPurposeId": transferPurposeId == null ? null : transferPurposeId,
    "activeStatus": activeStatus == null ? null : activeStatus,
    "createdBy": createdBy == null ? null : createdBy,
    "createdDate": createdDate == null ? null : "${createdDate!.year.toString().padLeft(4, '0')}-${createdDate!.month.toString().padLeft(2, '0')}-${createdDate!.day.toString().padLeft(2, '0')}",
    "federalPurposeCode": federalPurposeCode == null ? null : federalPurposeCode,
    "trangloPurposeCode": trangloPurposeCode == null ? null : trangloPurposeCode,
    "transferPurposeName": transferPurposeName == null ? null : transferPurposeName,
    "updatedBy": updatedBy,
    "updatedDate": updatedDate,
    "versionId": versionId == null ? null : versionId,
  };
}
