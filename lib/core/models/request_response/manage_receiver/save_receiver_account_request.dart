// To parse this JSON data, do
//
//     final saveReceiverAccountRequest = saveReceiverAccountRequestFromJson(jsonString);

import 'dart:convert';

SaveReceiverAccountRequest saveReceiverAccountRequestFromJson(String str) => SaveReceiverAccountRequest.fromJson(json.decode(str));

String saveReceiverAccountRequestToJson(SaveReceiverAccountRequest data) => json.encode(data.toJson());

class SaveReceiverAccountRequest {
  SaveReceiverAccountRequest({
    this.accountNumber,
    this.accountType,
    this.activeStatus,
    this.bankId,
    this.branchId,
    this.businessCateogry,
    this.city,
    this.contactId,
    this.createdBy,
    this.countryId,
    this.firstName,
    this.lastName,
    this.middleName,
    this.phoneNumber,
    this.postalCode,
    this.receiverType,
    this.residenceAddress,
    this.senderRelationship,
    this.state,
    this.versionId,
    this.wireTransferModeId,
    this.nationalityId,
    this.isSwift,
    this.isSwiftEuro,
  });

  String? accountNumber;
  String? accountType;
  int? activeStatus;
  int? bankId;
  int? branchId;
  String? businessCateogry;
  dynamic city;
  int? contactId;
  String? createdBy;
  int? countryId;
  String? firstName;
  String? lastName;
  String? middleName;
  String? phoneNumber;
  String? postalCode;
  String? receiverType;
  String? residenceAddress;
  int? senderRelationship;
  dynamic state;
  int? versionId;
  int? wireTransferModeId;
  int? nationalityId;
  int? isSwift;
  int? isSwiftEuro;

  factory SaveReceiverAccountRequest.fromJson(Map<String, dynamic> json) => SaveReceiverAccountRequest(
    accountNumber: json["accountNumber"] == null ? null : json["accountNumber"],
    accountType: json["accountType"] == null ? null : json["accountType"],
    activeStatus: json["activeStatus"] == null ? null : json["activeStatus"],
    bankId: json["bankId"] == null ? null : json["bankId"],
    branchId: json["branchId"] == null ? null : json["branchId"],
    businessCateogry: json["businessCateogry"] == null ? null : json["businessCateogry"],
    city: json["city"],
    contactId: json["contactId"] == null ? null : json["contactId"],
    createdBy: json["createdBy"] == null ? null : json["createdBy"],
    countryId: json["countryId"] == null ? null : json["countryId"],
    firstName: json["firstName"] == null ? null : json["firstName"],
    lastName: json["lastName"] == null ? null : json["lastName"],
    middleName: json["middleName"] == null ? null : json["middleName"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    postalCode: json["postalCode"] == null ? null : json["postalCode"],
    receiverType: json["receiverType"] == null ? null : json["receiverType"],
    residenceAddress: json["residenceAddress"] == null ? null : json["residenceAddress"],
    senderRelationship: json["senderRelationship"] == null ? null : json["senderRelationship"],
    state: json["state"],
    versionId: json["versionId"] == null ? null : json["versionId"],
    wireTransferModeId: json["wireTransferModeId"] == null ? null : json["wireTransferModeId"],
    nationalityId: json["nationalityId"] == null ? null : json["nationalityId"],
    isSwift: json["isSwift"] == null ? null : json["isSwift"],
    isSwiftEuro: json["isSwiftEuro"] == null ? null : json["isSwiftEuro"],
  );

  Map<String, dynamic> toJson() => {
    "accountNumber": accountNumber == null ? null : accountNumber,
    "accountType": accountType == null ? null : accountType,
    "activeStatus": activeStatus == null ? null : activeStatus,
    "bankId": bankId == null ? null : bankId,
    "branchId": branchId == null ? null : branchId,
    "businessCateogry": businessCateogry == null ? null : businessCateogry,
    "city": city,
    "contactId": contactId == null ? null : contactId,
    "createdBy": createdBy == null ? null : createdBy,
    "countryId": countryId == null ? null : countryId,
    "firstName": firstName == null ? null : firstName,
    "lastName": lastName == null ? null : lastName,
    "middleName": middleName == null ? null : middleName,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "postalCode": postalCode == null ? null : postalCode,
    "receiverType": receiverType == null ? null : receiverType,
    "residenceAddress": residenceAddress == null ? null : residenceAddress,
    "senderRelationship": senderRelationship == null ? null : senderRelationship,
    "state": state,
    "versionId": versionId == null ? null : versionId,
    "wireTransferModeId": wireTransferModeId == null ? null : wireTransferModeId,
    "nationalityId": nationalityId == null ? null : nationalityId,
    "isSwift": isSwift == null ? null : isSwift,
    "isSwiftEuro": isSwiftEuro == null ? null : isSwiftEuro,
  };
}
