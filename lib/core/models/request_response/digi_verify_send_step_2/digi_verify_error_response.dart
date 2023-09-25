// To parse this JSON data, do
//
//     final GetStepTwoErrorResponse = GetStepTwoErrorResponseFromJson(jsonString);

import 'dart:convert';

GetStepTwoErrorResponse GetStepTwoErrorResponseFromJson(String str) => GetStepTwoErrorResponse.fromJson(json.decode(str));

String GetStepTwoErrorResponseToJson(GetStepTwoErrorResponse data) => json.encode(data.toJson());

class GetStepTwoErrorResponse {
  GetStepTwoErrorResponse({
    this.message,
    this.attempts,
    this.custOnboardDocBeans,
    this.errorList,
    this.statusId,
    this.cra,
    this.driverLicense,
    this.medicare,
    this.passport,
    this.aml,
    this.status,
  });

  String? message;
  int? attempts;
  CustOnboardDocBeans? custOnboardDocBeans;
  List<String>? errorList;
  int? statusId;
  bool? cra;
  bool? driverLicense;
  bool? medicare;
  bool? passport;
  bool? aml;
  String? status;

  factory GetStepTwoErrorResponse.fromJson(Map<String, dynamic> json) => GetStepTwoErrorResponse(
    message: json["message"] == null ? null : json["message"],
    attempts: json["attempts"] == null ? null : json["attempts"],
    custOnboardDocBeans: json["custOnboardDocBeans"] == null ? null : CustOnboardDocBeans.fromJson(json["custOnboardDocBeans"]),
    errorList: json["errorList"] == null ? null : List<String>.from(json["errorList"].map((x) => x)),
    statusId: json["statusId"] == null ? null : json["statusId"],
    cra: json["cra"] == null ? null : json["cra"],
    driverLicense: json["driverLicense"] == null ? null : json["driverLicense"],
    medicare: json["medicare"] == null ? null : json["medicare"],
    passport: json["passport"] == null ? null : json["passport"],
    aml: json["aml"] == null ? null : json["aml"],
    status: json["status"] == null ? null : json["status"],
  );

  Map<String, dynamic> toJson() => {
    "message": message == null ? null : message,
    "attempts": attempts == null ? null : attempts,
    "custOnboardDocBeans": custOnboardDocBeans == null ? null : custOnboardDocBeans!.toJson(),
    "errorList": errorList == null ? null : List<dynamic>.from(errorList!.map((x) => x)),
    "statusId": statusId == null ? null : statusId,
    "cra": cra == null ? null : cra,
    "driverLicense": driverLicense == null ? null : driverLicense,
    "medicare": medicare == null ? null : medicare,
    "passport": passport == null ? null : passport,
    "aml": aml == null ? null : aml,
    "status": status == null ? null : status,
  };
}

class CustOnboardDocBeans {
  CustOnboardDocBeans({
    this.passport,
    this.australianDrivingLicense,
    this.medicareCard,
  });

  AustralianDrivingLicense? passport;
  AustralianDrivingLicense? australianDrivingLicense;
  AustralianDrivingLicense? medicareCard;

  factory CustOnboardDocBeans.fromJson(Map<String, dynamic> json) => CustOnboardDocBeans(
    passport: json["Passport"] == null ? null : AustralianDrivingLicense.fromJson(json["Passport"]),
    australianDrivingLicense: json["Australian-Driving-License"] == null ? null : AustralianDrivingLicense.fromJson(json["Australian-Driving-License"]),
    medicareCard: json["Medicare-Card"] == null ? null : AustralianDrivingLicense.fromJson(json["Medicare-Card"]),
  );

  Map<String, dynamic> toJson() => {
    "Passport": passport == null ? null : passport!.toJson(),
    "Australian-Driving-License": australianDrivingLicense == null ? null : australianDrivingLicense!.toJson(),
    "Medicare-Card": medicareCard == null ? null : medicareCard!.toJson(),
  };
}

class AustralianDrivingLicense {
  AustralianDrivingLicense({
    this.documentId,
    this.documentName,
    this.contactId,
    this.referenceNumber,
    this.issueDate,
    this.expiryDate,
    this.issuingAuthority,
    this.cardColour,
    this.countryOfIssue,
    this.individualRefNo,
    this.medicareCardName,
    this.isDocVerified,
    this.dlFName,
    this.dlMName,
    this.dlLName,
    this.ppFName,
    this.ppMName,
    this.ppLName,
    this.gender,
  });

  int? documentId;
  String? documentName;
  int? contactId;
  String? referenceNumber;
  String? issueDate;
  DateTime? expiryDate;
  String? issuingAuthority;
  String? cardColour;
  String? countryOfIssue;
  String? individualRefNo;
  String? medicareCardName;
  int? isDocVerified;
  String? dlFName;
  String? dlMName;
  String? dlLName;
  String? ppFName;
  String? ppMName;
  String? ppLName;
  String? gender;

  factory AustralianDrivingLicense.fromJson(Map<String, dynamic> json) => AustralianDrivingLicense(
    documentId: json["documentId"] == null ? null : json["documentId"],
    documentName: json["documentName"] == null ? null : json["documentName"],
    contactId: json["contactId"] == null ? null : json["contactId"],
    referenceNumber: json["referenceNumber"] == null ? null : json["referenceNumber"],
    issueDate: json["issueDate"] == null ? null : json["issueDate"],
    expiryDate: json["expiryDate"] == null ? null : DateTime.parse(json["expiryDate"]),
    issuingAuthority: json["issuingAuthority"] == null ? null : json["issuingAuthority"],
    cardColour: json["cardColour"] == null ? null : json["cardColour"],
    countryOfIssue: json["countryOfIssue"] == null ? null : json["countryOfIssue"],
    individualRefNo: json["individualRefNo"] == null ? null : json["individualRefNo"],
    medicareCardName: json["medicareCardName"] == null ? null : json["medicareCardName"],
    isDocVerified: json["isDocVerified"] == null ? null : json["isDocVerified"],
    dlFName: json["dlFName"] == null ? null : json["dlFName"],
    dlMName: json["dlMName"] == null ? null : json["dlMName"],
    dlLName: json["dlLName"] == null ? null : json["dlLName"],
    ppFName: json["ppFName"] == null ? null : json["ppFName"],
    ppMName: json["ppMName"] == null ? null : json["ppMName"],
    ppLName: json["ppLName"] == null ? null : json["ppLName"],
    gender: json["gender"] == null ? null : json["gender"],
  );

  Map<String, dynamic> toJson() => {
    "documentId": documentId == null ? null : documentId,
    "documentName": documentName == null ? null : documentName,
    "contactId": contactId == null ? null : contactId,
    "referenceNumber": referenceNumber == null ? null : referenceNumber,
    "issueDate": issueDate == null ? null : issueDate,
    "expiryDate": expiryDate == null ? null : "${expiryDate!.year.toString().padLeft(4, '0')}-${expiryDate!.month.toString().padLeft(2, '0')}-${expiryDate!.day.toString().padLeft(2, '0')}",
    "issuingAuthority": issuingAuthority == null ? null : issuingAuthority,
    "cardColour": cardColour == null ? null : cardColour,
    "countryOfIssue": countryOfIssue == null ? null : countryOfIssue,
    "individualRefNo": individualRefNo == null ? null : individualRefNo,
    "medicareCardName": medicareCardName == null ? null : medicareCardName,
    "isDocVerified": isDocVerified == null ? null : isDocVerified,
    "dlFName": dlFName == null ? null : dlFName,
    "dlMName": dlMName == null ? null : dlMName,
    "dlLName": dlLName == null ? null : dlLName,
    "ppFName": ppFName == null ? null : ppFName,
    "ppMName": ppMName == null ? null : ppMName,
    "ppLName": ppLName == null ? null : ppLName,
    "gender": gender == null ? null : gender,
  };
}
