// To parse this JSON data, do
//
//     final receiverDetailsByCountryIdResponse = receiverDetailsByCountryIdResponseFromJson(jsonString);

import 'dart:convert';

List<ReceiverDetailsByCountryIdResponse> receiverDetailsByCountryIdResponseFromJson(String str) => List<ReceiverDetailsByCountryIdResponse>.from(json.decode(str).map((x) => ReceiverDetailsByCountryIdResponse.fromJson(x)));

String receiverDetailsByCountryIdResponseToJson(List<ReceiverDetailsByCountryIdResponse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReceiverDetailsByCountryIdResponse {
  ReceiverDetailsByCountryIdResponse({
    this.receiverAccountId,
    this.accountNumber,
    this.accountType,
    this.activeStatus,
    this.bankId,
    this.branchId,
    this.businessCateogry,
    this.city,
    this.companyRegNo,
    this.countryId,
    this.createdBy,
    this.createdDate,
    this.firstName,
    this.lastName,
    this.middleName,
    this.nationalityId,
    this.phoneNumber,
    this.postalCode,
    this.receiverType,
    this.residenceAddress,
    this.senderRelationship,
    this.state,
    this.updatedBy,
    this.updatedDate,
    this.versionId,
    this.wireTransferModeId,
    this.contactId,
    this.swiftCode,
    this.iban,
    this.branchCode,
    this.idType,
    this.idnumber,
    this.expdate,
    this.idPlaceIssue,

  });

  int? receiverAccountId;
  String? accountNumber;
  String? accountType;
  int? activeStatus;
  int? bankId;
  int? branchId;
  String? businessCateogry;
  String? city;
  String? companyRegNo;
  int? countryId;
  String? createdBy;
  String? firstName;
  String? lastName;
  String? middleName;
  int? nationalityId;
  String? phoneNumber;
  String? postalCode;
  String? receiverType;
  String? residenceAddress;
  int? senderRelationship;
  String? state;
  dynamic updatedBy;
  dynamic updatedDate;
  int? versionId;
  int? wireTransferModeId;
  int? contactId;
  String? swiftCode;
  String? iban;
  dynamic branchCode;
  int? idType;
  dynamic idnumber;
  dynamic expdate;
  dynamic idPlaceIssue;
  String? createdDate;

  factory ReceiverDetailsByCountryIdResponse.fromJson(Map<String, dynamic> json) => ReceiverDetailsByCountryIdResponse(
    receiverAccountId: json["receiverAccountId"] == null ? null : json["receiverAccountId"],
    accountNumber: json["accountNumber"] == null ? null : json["accountNumber"],
    accountType: json["accountType"] == null ? null : json["accountType"],
    activeStatus: json["activeStatus"] == null ? null : json["activeStatus"],
    bankId: json["bankId"] == null ? null : json["bankId"],
    branchId: json["branchId"] == null ? null : json["branchId"],
    businessCateogry: json["businessCateogry"] == null ? null : json["businessCateogry"],
    city: json["city"] == null ? null : json["city"],
    companyRegNo: json["companyRegNo"] == null ? null : json["companyRegNo"],
    countryId: json["countryId"] == null ? null : json["countryId"],
    createdBy: json["createdBy"] == null ? null : json["createdBy"],
    createdDate: json["createdDate"] == null ? null : json["createdDate"],
    firstName: json["firstName"] == null ? null : json["firstName"],
    lastName: json["lastName"] == null ? null : json["lastName"],
    middleName: json["middleName"] == null ? null : json["middleName"],
    nationalityId: json["nationalityId"] == null ? null : json["nationalityId"],
    phoneNumber: json["phoneNumber"] == null ? null : json["phoneNumber"],
    postalCode: json["postalCode"] == null ? null : json["postalCode"],
    receiverType: json["receiverType"] == null ? null : json["receiverType"],
    residenceAddress: json["residenceAddress"] == null ? null : json["residenceAddress"],
    senderRelationship: json["senderRelationship"] == null ? null : json["senderRelationship"],
    state: json["state"] == null ? null : json["state"],
    updatedBy: json["updatedBy"],
    updatedDate: json["updatedDate"],
    versionId: json["versionId"] == null ? null : json["versionId"],
    wireTransferModeId: json["wireTransferModeId"] == null ? null : json["wireTransferModeId"],
    contactId: json["contactId"] == null ? null : json["contactId"],
    swiftCode: json["swiftCode"] == null ? null : json["swiftCode"],
    iban: json["iban"] == null ? null : json["iban"],
    branchCode: json["branchCode"],
    idType: json["idType"] == null ? null : json["idType"],
    idnumber: json["idnumber"],
    expdate: json["expdate"],
    idPlaceIssue: json["idPlaceIssue"],
  );

  Map<String, dynamic> toJson() => {
    "receiverAccountId": receiverAccountId == null ? null : receiverAccountId,
    "accountNumber": accountNumber == null ? null : accountNumber,
    "accountType": accountType == null ? null : accountType,
    "activeStatus": activeStatus == null ? null : activeStatus,
    "bankId": bankId == null ? null : bankId,
    "branchId": branchId == null ? null : branchId,
    "businessCateogry": businessCateogry == null ? null : businessCateogry,
    "city": city == null ? null : city,
    "companyRegNo": companyRegNo == null ? null : companyRegNo,
    "countryId": countryId == null ? null : countryId,
    "createdBy": createdBy == null ? null : createdBy,
    "createdDate": createdDate == null ? null : createdDate,
    "firstName": firstName == null ? null : firstName,
    "lastName": lastName == null ? null : lastName,
    "middleName": middleName == null ? null : middleName,
    "nationalityId": nationalityId == null ? null : nationalityId,
    "phoneNumber": phoneNumber == null ? null : phoneNumber,
    "postalCode": postalCode == null ? null : postalCode,
    "receiverType": receiverType == null ? null : receiverType,
    "residenceAddress": residenceAddress == null ? null : residenceAddress,
    "senderRelationship": senderRelationship == null ? null : senderRelationship,
    "state": state == null ? null : state,
    "updatedBy": updatedBy,
    "updatedDate": updatedDate,
    "versionId": versionId == null ? null : versionId,
    "wireTransferModeId": wireTransferModeId == null ? null : wireTransferModeId,
    "contactId": contactId == null ? null : contactId,
    "swiftCode": swiftCode == null ? null : swiftCode,
    "iban": iban == null ? null : iban,
    "branchCode": branchCode,
    "idType": idType == null ? null : idType,
    "idnumber": idnumber,
    "expdate": expdate,
    "idPlaceIssue": idPlaceIssue,
  };
}





