// To parse this JSON data, do
//
//     final saveSenderRequest = saveSenderRequestFromJson(jsonString);

import 'dart:convert';

SaveSenderRequest saveSenderRequestFromJson(String str) => SaveSenderRequest.fromJson(json.decode(str));

String saveSenderRequestToJson(SaveSenderRequest data) => json.encode(data.toJson());

class SaveSenderRequest {
  SaveSenderRequest({
    this.accountNumber,
    this.bankId,
    this.branchId,
    this.bsbOrAbaCode,
    this.contactId,
    this.countryId,
    this.createdBy,
    this.firstName,
    this.jointAcctHolderName,
    this.lastName,
    this.middleName,
    this.wireTransferModeId,
  });

  String? accountNumber;
  int? bankId;
  int? branchId;
  String? bsbOrAbaCode;
  int? contactId;
  int? countryId;
  int? createdBy;
  String? firstName;
  String? jointAcctHolderName;
  String? lastName;
  String? middleName;
  int? wireTransferModeId;

  factory SaveSenderRequest.fromJson(Map<String, dynamic> json) => SaveSenderRequest(
    accountNumber: json["accountNumber"] == null ? null : json["accountNumber"],
    bankId: json["bankId"] == null ? null : json["bankId"],
    branchId: json["branchId"] == null ? null : json["branchId"],
    bsbOrAbaCode: json["bsbOrABACode"] == null ? null : json["bsbOrABACode"],
    contactId: json["contactId"] == null ? null : json["contactId"],
    countryId: json["countryId"] == null ? null : json["countryId"],
    createdBy: json["createdBy"] == null ? null : json["createdBy"],
    firstName: json["firstName"] == null ? null : json["firstName"],
    jointAcctHolderName: json["jointAcctHolderName"] == null ? null : json["jointAcctHolderName"],
    lastName: json["lastName"] == null ? null : json["lastName"],
    middleName: json["middleName"] == null ? null : json["middleName"],
    wireTransferModeId: json["wireTransferModeId"] == null ? null : json["wireTransferModeId"],
  );

  Map<String, dynamic> toJson() => {
    "accountNumber": accountNumber == null ? null : accountNumber,
    "bankId": bankId == null ? null : bankId,
    "branchId": branchId == null ? null : branchId,
    "bsbOrABACode": bsbOrAbaCode == null ? null : bsbOrAbaCode,
    "contactId": contactId == null ? null : contactId,
    "countryId": countryId == null ? null : countryId,
    "createdBy": createdBy == null ? null : createdBy,
    "firstName": firstName == null ? null : firstName,
    "jointAcctHolderName": jointAcctHolderName == null ? null : jointAcctHolderName,
    "lastName": lastName == null ? null : lastName,
    "middleName": middleName == null ? null : middleName,
    "wireTransferModeId": wireTransferModeId == null ? null : wireTransferModeId,
  };
}
