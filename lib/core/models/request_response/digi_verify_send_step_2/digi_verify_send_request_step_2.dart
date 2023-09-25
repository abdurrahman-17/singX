// To parse this JSON data, do
//
//     final digiVerifyStepTwoRequestSendAus = digiVerifyStepTwoRequestSendAusFromJson(jsonString);

import 'dart:convert';

DigiVerifyStepTwoRequestSendAus digiVerifyStepTwoRequestSendAusFromJson(String str) => DigiVerifyStepTwoRequestSendAus.fromJson(json.decode(str));

String digiVerifyStepTwoRequestSendAusToJson(DigiVerifyStepTwoRequestSendAus data) => json.encode(data.toJson());

class DigiVerifyStepTwoRequestSendAus {
  DigiVerifyStepTwoRequestSendAus({
    this.contactId,
    this.documentCount,
    this.onlyPassport,
    this.customerDocuments,
  });

  int? contactId;
  int? documentCount;
  bool? onlyPassport;
  List<CustomerDocument>? customerDocuments;

  factory DigiVerifyStepTwoRequestSendAus.fromJson(Map<String, dynamic> json) => DigiVerifyStepTwoRequestSendAus(
    contactId: json["contactId"] == null ? null : json["contactId"],
    documentCount: json["documentCount"] == null ? null : json["documentCount"],
    onlyPassport: json["onlyPassport"] == null ? null : json["onlyPassport"],
    customerDocuments: json["customerDocuments"] == null ? null : List<CustomerDocument>.from(json["customerDocuments"].map((x) => CustomerDocument.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "contactId": contactId == null ? null : contactId,
    "documentCount": documentCount == null ? null : documentCount,
    "onlyPassport": onlyPassport == null ? null : onlyPassport,
    "customerDocuments": customerDocuments == null ? null : List<dynamic>.from(customerDocuments!.map((x) => x.toJson())),
  };
}

class CustomerDocument {
  CustomerDocument({
    this.documenttype,
    this.referrenceNo,
    this.dateOfExpiry,
    this.stateOfIssue,
    this.cardType,
    this.indvReferrenceNo,
    this.mcName,
    this.dlFName,
    this.dlMName,
    this.dlLName,
    this.ppFName,
    this.ppMName,
    this.ppLName,
    this.gender,
    this.dlCardNo,
  });

  String? documenttype;
  String? referrenceNo;
  String? dateOfExpiry;
  String? stateOfIssue;
  dynamic cardType;
  dynamic indvReferrenceNo;
  dynamic mcName;
  String? dlFName;
  String? dlMName;
  String? dlLName;
  dynamic ppFName;
  dynamic ppMName;
  dynamic ppLName;
  dynamic gender;
  String? dlCardNo;

  factory CustomerDocument.fromJson(Map<String, dynamic> json) => CustomerDocument(
    documenttype: json["documenttype"] == null ? null : json["documenttype"],
    referrenceNo: json["referrenceNo"] == null ? null : json["referrenceNo"],
    dateOfExpiry: json["dateOfExpiry"] == null ? null : json["dateOfExpiry"],
    stateOfIssue: json["stateOfIssue"] == null ? null : json["stateOfIssue"],
    cardType: json["cardType"],
    indvReferrenceNo: json["indvReferrenceNo"],
    mcName: json["mcName"],
    dlFName: json["dlFName"] == null ? null : json["dlFName"],
    dlMName: json["dlMName"] == null ? null : json["dlMName"],
    dlLName: json["dlLName"] == null ? null : json["dlLName"],
    ppFName: json["ppFName"],
    ppMName: json["ppMName"],
    ppLName: json["ppLName"],
    gender: json["gender"],
    dlCardNo: json["dlCardNo"] == null ? null : json["dlCardNo"],
  );

  Map<String, dynamic> toJson() => {
    "documenttype": documenttype == null ? null : documenttype,
    "referrenceNo": referrenceNo == null ? null : referrenceNo,
    "dateOfExpiry": dateOfExpiry == null ? null : dateOfExpiry,
    "stateOfIssue": stateOfIssue == null ? null : stateOfIssue,
    "cardType": cardType,
    "indvReferrenceNo": indvReferrenceNo,
    "mcName": mcName,
    "dlFName": dlFName == null ? null : dlFName,
    "dlMName": dlMName == null ? null : dlMName,
    "dlLName": dlLName == null ? null : dlLName,
    "ppFName": ppFName,
    "ppMName": ppMName,
    "ppLName": ppLName,
    "gender": gender,
    "dlCardNo": dlCardNo == null ? null : dlCardNo,
  };
}
