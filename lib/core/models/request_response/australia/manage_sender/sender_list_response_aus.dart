// To parse this JSON data, do
//
//     final senderListResponseAus = senderListResponseAusFromJson(jsonString);

import 'dart:convert';

List<SenderListResponseAus> senderListResponseAusFromJson(String str) => List<SenderListResponseAus>.from(json.decode(str).map((x) => SenderListResponseAus.fromJson(x)));

String senderListResponseAusToJson(List<SenderListResponseAus> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class SenderListResponseAus {
  SenderListResponseAus({
    this.customerBankAcctId,
    this.contactId,
    this.accountNumber,
    this.bsbOrAbaCode,
    this.activeStatus,
    this.bankId,
    this.branchId,
    this.countryId,
    this.createdBy,
    this.createdDate,
    this.firstName,
    this.jointAcctHolderName,
    this.lastName,
    this.middleName,
    this.bankName,
    this.updatedBy,
    this.updatedDate,
    this.versionId,
    this.wireTransferModeId,
  });

  int? customerBankAcctId;
  int? contactId;
  String? accountNumber;
  String? bsbOrAbaCode;
  int? activeStatus;
  int? bankId;
  int? branchId;
  int? countryId;
  String? createdBy;
  String? createdDate;
  String? firstName;
  String? jointAcctHolderName;
  String? lastName;
  String? middleName;
  String? bankName;
  String? updatedBy;
  String? updatedDate;
  int? versionId;
  int? wireTransferModeId;

  factory SenderListResponseAus.fromJson(Map<String, dynamic> json) => SenderListResponseAus(
    customerBankAcctId: json["customerBankAcctId"] == null ? null : json["customerBankAcctId"],
    contactId: json["contactId"] == null ? null : json["contactId"],
    accountNumber: json["accountNumber"] == null ? null : json["accountNumber"],
    bsbOrAbaCode: json["bsbOrABACode"] == null ? null : json["bsbOrABACode"],
    activeStatus: json["activeStatus"] == null ? null : json["activeStatus"],
    bankId: json["bankId"] == null ? null : json["bankId"],
    branchId: json["branchId"] == null ? null : json["branchId"],
    countryId: json["countryId"] == null ? null : json["countryId"],
    createdBy: json["createdBy"] == null ? null : json["createdBy"],
    createdDate: json["createdDate"] == null ? null : json["createdDate"],
    firstName: json["firstName"] == null ? null : json["firstName"],
    jointAcctHolderName: json["jointAcctHolderName"] == null ? null : json["jointAcctHolderName"],
    lastName: json["lastName"] == null ? null : json["lastName"],
    middleName: json["middleName"] == null ? null : json["middleName"],
    bankName: json["bankName"] == null ? null : json["bankName"],
    updatedBy: json["updatedBy"] == null ? null : json["updatedBy"],
    updatedDate: json["updatedDate"] == null ? null : json["updatedDate"],
    versionId: json["versionId"] == null ? null : json["versionId"],
    wireTransferModeId: json["wireTransferModeId"] == null ? null : json["wireTransferModeId"],
  );

  Map<String, dynamic> toJson() => {
    "customerBankAcctId": customerBankAcctId == null ? null : customerBankAcctId,
    "contactId": contactId == null ? null : contactId,
    "accountNumber": accountNumber == null ? null : accountNumber,
    "bsbOrABACode": bsbOrAbaCode == null ? null : bsbOrAbaCode,
    "activeStatus": activeStatus == null ? null : activeStatus,
    "bankId": bankId == null ? null : bankId,
    "branchId": branchId == null ? null : branchId,
    "countryId": countryId == null ? null : countryId,
    "createdBy": createdBy == null ? null : createdBy,
    "createdDate": createdDate == null ? null : createdDate,
    "firstName": firstName == null ? null : firstName,
    "jointAcctHolderName": jointAcctHolderName == null ? null : jointAcctHolderName,
    "lastName": lastName == null ? null : lastName,
    "middleName": middleName == null ? null : middleName,
    "bankName": bankName == null ? null : bankName,
    "updatedBy": updatedBy == null ? null : updatedBy,
    "updatedDate": updatedDate == null ? null : updatedDate,
    "versionId": versionId == null ? null : versionId,
    "wireTransferModeId": wireTransferModeId == null ? null : wireTransferModeId,
  };

  @override
  String toString() {
    return '$firstName $bankName $accountNumber'.toLowerCase();
  }
}
